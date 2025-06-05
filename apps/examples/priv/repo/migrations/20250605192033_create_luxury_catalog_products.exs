defmodule Examples.Repo.Migrations.CreateLuxuryCatalogProducts do
  use Ecto.Migration

  def change do
    create table(:luxury_catalog_products) do
      add :name, :string, null: false
      add :permitted_category_codes, {:array, :string}
      add :max_category_count, :integer
      add :max_category_member_count, :integer
      add :state, :string, null: false
      add :color, :string, null: false
      add :price, :decimal, null: false

      timestamps()
    end

    create unique_index(:luxury_catalog_products, [:name])
  end
end
