defmodule Examples.Repo.Migrations.CreateLuxuryCategoryConflicts do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_category_conflicts) do
      add :category_id, references(:luxury_catalog_categories, on_delete: :nothing), null: false

      add :conflicted_category_id, references(:luxury_catalog_categories, on_delete: :nothing),
        null: false
    end

    create unique_index(:luxury_catalog_category_conflicts, [
             :category_id,
             :conflicted_category_id
           ])
  end
end
