defmodule Examples.Repo.Migrations.CreateLuxuryCatalogCategories do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_categories) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :max_product_count, :integer, null: true
      add :permitted_product_colors, {:array, :string}
      add :permitted_product_price_range, :numrange
      add :state, :string, null: false
      add :mutually_exclusive, :boolean, null: false

      timestamps()
    end

    create unique_index(:luxury_catalog_categories, [:name])
    create unique_index(:luxury_catalog_categories, [:code])
  end
end
