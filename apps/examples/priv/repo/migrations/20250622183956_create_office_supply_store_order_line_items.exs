defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreOrderLineItems do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_order_line_items) do
      add :quantity, :integer
      add :price, :decimal
      add :order_id, references(:office_supply_store_orders, on_delete: :nothing)

      timestamps()
    end

    create index(:office_supply_store_order_line_items, [:order_id])
  end
end
