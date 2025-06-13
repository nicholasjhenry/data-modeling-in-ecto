defmodule Examples.Repo.Migrations.CreatePublicLibraryBranches do
  use Ecto.Migration

  def change do
    create table(:public_library_branches) do
      add :name, :string

      timestamps()
    end
  end
end
