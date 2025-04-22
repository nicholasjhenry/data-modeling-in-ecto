defmodule Nomify.Repo.Migrations.CreateDirectoryPeople do
  use Ecto.Migration

  def change do
    create table(:directory_people) do
      add :title, :string
      add :name, :string
      add :email, :string

      timestamps()
    end
  end
end
