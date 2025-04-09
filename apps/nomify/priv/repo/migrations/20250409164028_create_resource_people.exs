defmodule Nomify.Repo.Migrations.CreateResourcePeople do
  use Ecto.Migration

  def change do
    create table(:resource_people) do
      add :title, :string
      add :name, :string
      add :email, :string

      timestamps()
    end
  end
end
