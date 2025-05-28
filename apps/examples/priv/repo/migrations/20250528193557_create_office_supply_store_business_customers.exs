defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreBusinessCustomers do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_business_customers) do
      add :registered_on, :date
      add :organization_id, references(:office_supply_store_organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:office_supply_store_business_customers, [:organization_id])
  end
end
