defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreDeliveryLineItems do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_delivery_line_items) do
      add :quantity, :integer, null: false

      add :delivery_id, references(:office_supply_store_deliveries, on_delete: :nothing),
        null: false

      add :order_line_item_id,
          references(:office_supply_store_order_line_items, on_delete: :nothing),
          null: false

      timestamps()
    end

    create index(:office_supply_store_delivery_line_items, [:delivery_id, :order_line_item_id])
  end
end
