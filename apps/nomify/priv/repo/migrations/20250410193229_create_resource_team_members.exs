defmodule Nomify.Repo.Migrations.CreateResourceTeamMembers do
  use Ecto.Migration

  def change do
    create table(:resource_team_members) do
      add :team_role, :string
      add :privileges, :integer
      add :security_level, :string
      add :person_id, references(:resource_people, on_delete: :nothing)
      add :team_id, references(:resource_teams, on_delete: :nothing)

      timestamps()
    end

    create index(:resource_team_members, [:person_id])
    create index(:resource_team_members, [:team_id])
  end
end
