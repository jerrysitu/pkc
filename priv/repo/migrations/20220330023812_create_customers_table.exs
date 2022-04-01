defmodule PeekChallenge.Repo.Migrations.CreateCustomersTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:customers, primary_key: false) do
      add(:uuid, :uuid, primary_key: true)
      add(:email, :citext, null: false)

      timestamps()
    end

    create(unique_index(:customers, [:email]))
  end
end
