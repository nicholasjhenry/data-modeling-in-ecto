defmodule Examples.Repo.Migrations.CreateOfficeSupplyDeliveries do
  use Ecto.Migration

  def change do
    create table(:office_supply_deliveries) do
      add :type, :string, null: false
      add :state, :string, null: false
      add :address, :string, null: false
      add :order_id, references(:office_supply_store_orders, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:office_supply_deliveries, [:order_id])
  end
end
