defmodule PeekChallenge.Shop.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeekChallenge.Account.Customer
  alias PeekChallenge.Shop.Payment

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :uuid}
  schema "orders" do
    field :original_value, :float
    field :current_balance, :float, default: 0.0

    belongs_to :customer, Customer,
      foreign_key: :customer_uuid,
      references: :uuid,
      type: :binary_id

    has_many :payments, Payment

    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :original_value,
      :current_balance,
      :customer_uuid
    ])
    |> validate_required([:original_value])
  end
end
