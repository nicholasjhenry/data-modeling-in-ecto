defmodule Nomify.Repo.Migrations.AddPersonIdToAccountUsers do
  use Ecto.Migration

  def change do
    alter table(:account_users) do
      add :person_id, references(:directory_people, on_delete: :delete_all), null: false
    end

    create index(:account_users, :person_id, unique: true)
  end
end
