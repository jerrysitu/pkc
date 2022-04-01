defmodule PeekChallenge.Repo.Migrations.CreatePaymentsTable do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :amount, :float
      add :valid, :boolean

      add :order_uuid, references(:orders, type: :uuid, column: :uuid)
      add :customer_uuid, references(:customers, type: :uuid, column: :uuid)

      timestamps()
    end
  end
end
