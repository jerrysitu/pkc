defmodule PeekChallenge.Account.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeekChallenge.Shop.{Order, Payment}

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :uuid}
  schema "customers" do
    field :email, :string

    has_many :orders, Order
    has_many :payments, Payment

    timestamps()
  end

  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [
      :email
    ])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end
end
