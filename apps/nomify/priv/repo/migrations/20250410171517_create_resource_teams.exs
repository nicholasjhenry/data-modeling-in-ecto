defmodule Nomify.Repo.Migrations.CreateResourceTeams do
  use Ecto.Migration

  def change do
    create table(:resource_teams) do
      add :description, :string
      add :format, :string

      timestamps()
    end
  end
end
