defmodule Examples.Repo.Migrations.AlterOfficeSupplyStoreProductsAddType do
  use Ecto.Migration

  def change do
    alter table(:office_supply_store_products) do
      add :type, :string, null: false
    end
  end
end
