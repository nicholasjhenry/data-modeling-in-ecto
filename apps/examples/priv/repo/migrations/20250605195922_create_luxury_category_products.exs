defmodule Examples.Repo.Migrations.CreateLuxuryCategoryProducts do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_category_products) do
      add :category_id, references(:luxury_catalog_categories, on_delete: :nothing), null: false
      add :product_id, references(:luxury_catalog_products, on_delete: :nothing), null: false
    end
  end
end
