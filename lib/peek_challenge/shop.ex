defmodule PeekChallenge.Shop do
  import Ecto.Query, warn: false
  alias PeekChallenge.Repo
  alias PeekChallenge.Shop.{Order, Payment}
  alias PeekChallenge.Account.Customer

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  def get_orders_for_customer_by_email!(email) do
    Customer
    |> where([customer], customer.email == ^email)
    |> join(:left, [customer], _ in assoc(customer, :orders))
    |> join(:left, [customer, orders], _ in assoc(orders, :payments))
    |> preload([customer, orders, payments], orders: {orders, payments: payments})
    |> Repo.one()
    # TODO: this can be a subquery
    |> maybe_orders()
  end

  def get_order(order_uuid) do
    Order
    |> where([order], order.uuid == ^order_uuid)
    |> join(:left, [order], _ in assoc(order, :payments))
    |> preload([order, payments], payments: payments)
    |> Repo.one()
    |> maybe_order()
  end

  defp maybe_orders(nil), do: {:error, "no customer matching email"}

  defp maybe_orders(customer) do
    customer.orders
    |> Enum.reject(fn order ->
      order.payments
      |> Enum.any?(fn payment ->
        payment.valid == false
      end)
    end)
  end

  defp maybe_order(order) do
    if Enum.any?(order.payments, fn payment ->
         payment.valid == false
       end) do
      nil
    else
      order
    end
  end
end
