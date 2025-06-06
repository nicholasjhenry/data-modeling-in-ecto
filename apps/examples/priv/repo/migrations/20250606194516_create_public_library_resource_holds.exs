defmodule Examples.Repo.Migrations.CreatePublicLibraryResourceHolds do
  use Ecto.Migration

  def change do
    create table(:public_library_resource_holds) do
      add :type, :string
      add :permit_resource_fees, :boolean, default: false, null: false

      timestamps()
    end
  end
end
