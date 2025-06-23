defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreProducts do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_products) do
      add :name, :string
      add :price, :decimal

      timestamps()
    end
  end
end
