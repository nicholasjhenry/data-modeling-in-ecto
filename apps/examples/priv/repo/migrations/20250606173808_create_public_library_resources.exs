defmodule Examples.Repo.Migrations.CreatePublicLibraryResources do
  use Ecto.Migration

  def change do
    create table(:public_library_resources) do
      add :has_fee, :string

      timestamps()
    end
  end
end
