defmodule PeekChallenge.Support.Fixtures do
  alias PeekChallenge.Shop
  alias PeekChallenge.Accounts

  def order_fixture(attrs \\ %{}) do
    {:ok, order} = Shop.create_order(attrs)

    order
  end

  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} = Shop.create_payment(attrs)

    payment
  end

  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} = Accounts.create_customer(attrs)

    customer
  end
end
