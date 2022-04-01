defmodule PeekChallenge.Repo.Migrations.CreateOrdersTable do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :original_value, :float
      add :current_balance, :float

      add :customer_uuid, references(:customers, type: :uuid, column: :uuid)

      timestamps()
    end
  end
end
