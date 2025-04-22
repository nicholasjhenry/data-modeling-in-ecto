defmodule Nomify.Repo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def change do
    create table(:team_members) do
      add :role, :string
      add :privileges, :integer
      add :security_level, :string
      add :person_id, references(:directory_people, on_delete: :nothing), null: false
      add :team_id, references(:team_teams, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:team_members, [:team_id, :person_id], unique: true)
  end
end
