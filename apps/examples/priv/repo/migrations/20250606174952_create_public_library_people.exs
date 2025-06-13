defmodule Examples.Repo.Migrations.CreatePublicLibraryPeople do
  use Ecto.Migration

  def change do
    create table(:public_library_people) do
      add :name, :string
      add :born_on, :date

      timestamps()
    end
  end
end
