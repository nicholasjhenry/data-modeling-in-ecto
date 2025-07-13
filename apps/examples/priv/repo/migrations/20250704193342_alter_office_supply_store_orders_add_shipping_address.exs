defmodule Examples.Repo.Migrations.AlterOfficeSupplyStoreOrdersAddShippingAddress do
  use Ecto.Migration

  def change do
    alter table(:office_supply_store_orders) do
      add :shipping_address, :string, null: false
    end
  end
end
