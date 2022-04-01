defmodule PeekChallenge.Shop.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeekChallenge.Account.Customer
  alias PeekChallenge.Shop.Order

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :uuid}
  schema "payments" do
    field :amount, :float, null: false
    field :valid, :boolean

    belongs_to :order, Order,
      foreign_key: :order_uuid,
      references: :uuid,
      type: :binary_id

    belongs_to :customer, Customer,
      foreign_key: :customer_uuid,
      references: :uuid,
      type: :binary_id

    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :amount,
      :valid,
      :order_uuid
    ])
    |> validate_required([:amount])
  end
end
