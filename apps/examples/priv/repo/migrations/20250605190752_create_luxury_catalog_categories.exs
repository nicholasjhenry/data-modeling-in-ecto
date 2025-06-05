defmodule Examples.Repo.Migrations.CreateLuxuryCatalogCategories do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_categories) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :max_product_count, :integer, null: true
      add :permitted_colours, {:array, :string}, null: false
      add :permitted_price_range, :numrange, null: true
      add :state, :string, null: false
      add :mutually_exclusive, :boolean, null: false

      timestamps()
    end

    create unique_index(:luxury_catalog_categories, [:name])
    create unique_index(:luxury_catalog_categories, [:code])
  end
end
