defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreDeliveryLineItems do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_delivery_line_items) do
      add :quantity, :integer
      add :delivery_id, references(:office_supply_store_deliveries, on_delete: :nothing)
      add :order_line_item_id, references(:office_supply_store_order_line_items, on_delete: :nothing)

      timestamps()
    end

    create index(:office_supply_store_delivery_line_items, [:delivery_id])
    create index(:office_supply_store_delivery_line_items, [:order_line_item_id])
  end
end
