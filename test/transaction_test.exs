defmodule PeekChallenge.TransactionTest do
  use PeekChallenge.DataCase
  alias PeekChallenge.Shop
  alias PeekChallenge.Transaction
  import PeekChallenge.Support.Fixtures

  describe "apply_payment_to_order/2" do
    test "should pay down the original_value when payments are applied" do
      value = 50.00

      order = order_fixture(%{original_value: value, current_balance: value})

      [10.00, 10.00, 30.00]
      |> Enum.each(fn amount ->
        payment = payment_fixture(%{amount: amount, valid: true})

        Transaction.apply_payment_to_order(order.uuid, payment)
      end)

      order = Shop.get_order(order.uuid)

      assert order.current_balance == 0.0
    end
  end

  describe "create_order_and_pay/3" do
    test "returns 3 orders with 3 valid payments and 1 failed payments" do
      customer = customer_fixture(%{email: "kermit@muppet.com"})
      value = 100.00

      [true, true, true, false]
      |> Enum.shuffle()
      |> Enum.map(fn boolean ->
        payment = payment_fixture(%{amount: 20.00, valid: boolean})

        {:ok, order} = Transaction.create_order_and_pay(customer.uuid, value, payment)

        order
      end)

      customer_orders = Shop.get_orders_for_customer_by_email!(customer.email)

      assert length(customer_orders) == 3
    end
  end
end
