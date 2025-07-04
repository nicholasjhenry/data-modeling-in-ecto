defmodule Examples.Repo.Migrations.CreateOfficeSupplyDeliveries do
  use Ecto.Migration

  def change do
    create table(:office_supply_deliveries) do
      add :type, :string
      add :state, :string
      add :address, :string
      add :order_id, references(:office_supply_store_orders, on_delete: :nothing)

      timestamps()
    end

    create index(:office_supply_deliveries, [:order_id])
  end
end
