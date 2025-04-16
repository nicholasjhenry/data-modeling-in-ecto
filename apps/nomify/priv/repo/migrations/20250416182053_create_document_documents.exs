defmodule Nomify.Repo.Migrations.CreateDocumentDocuments do
  use Ecto.Migration

  def change do
    create table(:document_documents) do
      add :title, :string
      add :publication_date, :date
      add :security_level, :string

      timestamps()
    end
  end
end
