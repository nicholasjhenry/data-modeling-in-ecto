defmodule Nomify.Repo.Migrations.CreateDocumentNominations do
  use Ecto.Migration

  def change do
    create table(:document_nominations) do
      add :comments, :text
      add :status, :string
      add :nomination_date, :date
      add :document_id, references(:document_documents, on_delete: :nothing)
      add :team_member_id, references(:resource_team_members, on_delete: :nothing)

      timestamps()
    end

    create index(:document_nominations, [:document_id])
    create index(:document_nominations, [:team_member_id])
  end
end
