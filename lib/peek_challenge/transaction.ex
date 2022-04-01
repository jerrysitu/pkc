defmodule PeekChallenge.Transaction do
  alias PeekChallenge.Shop
  alias Shop.Payment

  def apply_payment_to_order(order_uuid, %Payment{} = payment) do
    Shop.update_payment(payment, %{order_uuid: order_uuid})

    order = Shop.get_order(order_uuid)

    valid_payment_amounts = get_valid_payments(order.payments)

    new_order_balance = determine_new_order_balance(order.original_value, valid_payment_amounts)

    Shop.update_order(order, %{current_balance: new_order_balance})
  end

  defp get_valid_payments(order_payments) do
    order_payments
    |> Enum.filter(fn payment -> payment.valid == true end)
    |> Enum.map(fn payment -> payment.amount end)
  end

  defp determine_new_order_balance(order_original_value, new_payments_with_valid_payments) do
    new_payments_with_valid_payments
    |> Enum.reduce(order_original_value, fn payment, acc ->
      acc - payment
    end)
  end

  def create_order_and_pay(customer_uuid, order_amount, %Payment{} = payment)
      when payment.valid do
    balance = order_amount - payment.amount

    {:ok, order} =
      Shop.create_order(%{
        customer_uuid: customer_uuid,
        original_value: order_amount,
        current_balance: balance
      })

    __MODULE__.apply_payment_to_order(order.uuid, payment)
  end

  def create_order_and_pay(customer_uuid, order_amount, %Payment{} = payment)
      when payment.valid == false do
    # Order is created, but will not be returned in any of the get get_order* functions.
    {:ok, order} =
      Shop.create_order(%{
        customer_uuid: customer_uuid,
        original_value: order_amount,
        current_balance: order_amount
      })

    # Update payment reference to order so we have a record of it even though it failed.
    Shop.update_payment(payment, %{order_uuid: order.uuid})
  end
end
