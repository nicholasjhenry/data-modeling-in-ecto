defmodule Examples.Repo.Migrations.AlterOfficeSupplyStoreBusinessCustomersAddStatus do
  use Ecto.Migration

  def change do
    alter table(:office_supply_store_business_customers) do
      add :status, :string, null: false
    end
  end
end
