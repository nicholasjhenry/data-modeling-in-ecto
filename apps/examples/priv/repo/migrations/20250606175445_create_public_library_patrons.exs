defmodule Examples.Repo.Migrations.CreatePublicLibraryPatrons do
  use Ecto.Migration

  def change do
    create table(:public_library_patrons) do
      add :type, :string
      add :state, :string
      add :registration_number, :string
      add :person_id, references(:public_library_people, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:public_library_patrons, [:registration_number])
    create index(:public_library_patrons, [:person_id])
  end
end
