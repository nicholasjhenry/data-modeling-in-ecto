defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreOrders do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_orders) do
      add :state, :string
      add :type, :string

      timestamps()
    end
  end
end
