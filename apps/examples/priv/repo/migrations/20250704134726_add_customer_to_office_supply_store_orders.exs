defmodule Examples.Repo.Migrations.AddCustomerToOfficeSupplyStoreOrders do
  use Ecto.Migration

  def change do
    alter table(:office_supply_store_orders) do
      add :customer_id, references(:office_supply_store_business_customers, on_delete: :nothing),
        null: false
    end

    create index(:office_supply_store_orders, :customer_id)
  end
end
