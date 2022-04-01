defmodule PeekChallenge.Accounts do
  import Ecto.Query, warn: false
  alias PeekChallenge.Repo
  alias PeekChallenge.Account.Customer

  def get_customer(uuid) do
    Customer
    |> where([customer], customer.uuid == ^uuid)
    |> join(:left, [customer], _ in assoc(customer, :orders))
    |> join(:left, [customer, orders], _ in assoc(orders, :payments))
    |> preload([customer, orders, payments], orders: {orders, payments: payments})
    |> Repo.one()
  end

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end
end
