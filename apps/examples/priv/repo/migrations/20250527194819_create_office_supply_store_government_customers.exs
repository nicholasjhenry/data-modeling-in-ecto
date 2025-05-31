defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreGovernmentCustomers do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_government_customers) do
      add :registered_on, :date

      add :organization_id, references(:office_supply_store_organizations, on_delete: :nothing),
        null: false

      timestamps()
    end

    create index(:office_supply_store_government_customers, [:organization_id])
  end
end
