defmodule Examples.Repo.Migrations.CreateLuxuryCatalogCategories do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_categories) do
      add :name, :string
      add :max_product_count, :integer
      add :permitted_colours, {:array, :string}
      add :permitted_price_range, :decimal
      add :state, :string
      add :mutually_exclusive, :string

      timestamps()
    end

    create unique_index(:luxury_catalog_categories, [:name])
  end
end
