defmodule Examples.Repo.Migrations.CreatePublicLibraryResourceHolds do
  use Ecto.Migration

  def change do
    create table(:public_library_resource_holds) do
      add :type, :string
      add :permit_resource_fees, :boolean, default: false, null: false
      add :patron_id, references(:public_library_patrons, on_delete: :nothing)
      add :resource_id, references(:public_library_resources, on_delete: :nothing)
      add :branch_id, references(:public_library_branches, on_delete: :nothing)

      timestamps()
    end
  end
end
