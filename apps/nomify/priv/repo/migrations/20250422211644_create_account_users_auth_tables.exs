defmodule Nomify.Repo.Migrations.CreateAccountUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:account_users) do
      add :email, :citext, null: false
      add :hashed_password, :string
      add :confirmed_at, :naive_datetime

      timestamps()
    end

    create unique_index(:account_users, [:email])

    create table(:account_users_tokens) do
      add :user_id, references(:account_users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(updated_at: false)
    end

    create index(:account_users_tokens, [:user_id])
    create unique_index(:account_users_tokens, [:context, :token])
  end
end
