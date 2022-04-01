defmodule PeekChallenge.ShopTest do
  use PeekChallenge.DataCase
  alias PeekChallenge.Shop
  import PeekChallenge.Support.Fixtures

  describe "create_order/1" do
    test "should create order with provided value and balance" do
      value = 100.00
      assert {:ok, order} = Shop.create_order(%{original_value: value, balance: value})
      assert order.original_value == 100.00
    end
  end

  describe "get_order/1" do
    # TODO: Add test setup
    test "should get order with included payments" do
      customer = customer_fixture(%{email: "ernie@muppet.com"})
      value = 100.00

      original_order =
        order_fixture(%{
          original_value: value,
          current_balance: value,
          customer_uuid: customer.uuid
        })

      0..1
      |> Enum.map(fn _x ->
        payment_fixture(%{order_uuid: original_order.uuid, amount: 20, valid: true})
      end)

      order = Shop.get_order(original_order.uuid)

      assert original_order.uuid == order.uuid
      assert length(order.payments) == 2
    end

    test "should not return order when payment is invalid" do
      customer = customer_fixture(%{email: "ernie@muppet.com"})
      value = 100.00

      original_order =
        order_fixture(%{
          original_value: value,
          current_balance: value,
          customer_uuid: customer.uuid
        })

      0..1
      |> Enum.map(fn _x ->
        payment_fixture(%{order_uuid: original_order.uuid, amount: 20, valid: false})
      end)

      assert Shop.get_order(original_order.uuid) == nil
    end
  end

  describe "get_orders_for_customer/1" do
    test "should get orders given an existing customer email" do
      customer = customer_fixture(%{email: "bert@muppet.com"})

      0..2
      |> Enum.each(fn _x ->
        order_fixture(%{original_value: 100.00, customer_uuid: customer.uuid})
      end)

      orders = Shop.get_orders_for_customer_by_email!(customer.email)

      assert length(orders) == 3
    end

    test "should return error when provided with a non-existing customer email" do
      assert {:error, "no customer matching email"} ==
               Shop.get_orders_for_customer_by_email!("phony@company.com")
    end
  end
end
