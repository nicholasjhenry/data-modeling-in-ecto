defmodule Examples.Repo.Migrations.AddBranchToOfficeSupplyStoreOrders do
  use Ecto.Migration

  def change do
    alter table(:office_supply_store_orders) do
      add :branch_id, references(:office_supply_store_branches, on_delete: :nothing)
    end

    create index(:office_supply_store_orders, :branch_id)
  end
end
