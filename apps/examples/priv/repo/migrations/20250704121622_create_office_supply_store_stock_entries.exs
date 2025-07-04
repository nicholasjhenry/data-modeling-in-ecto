defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreStockEntries do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_stock_entries) do
      add :branch_id, references(:office_supply_store_branches, on_delete: :nothing)
      add :product_id, references(:office_supply_store_products, on_delete: :nothing)

      timestamps()
    end

    create index(:office_supply_store_stock_entries, [:branch_id, :product_id], unique: true)
  end
end
