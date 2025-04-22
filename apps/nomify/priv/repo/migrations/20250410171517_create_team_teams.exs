defmodule Nomify.Repo.Migrations.CreateTeamTeams do
  use Ecto.Migration

  def change do
    create table(:team_teams) do
      add :description, :string
      add :format, :string

      timestamps()
    end
  end
end
