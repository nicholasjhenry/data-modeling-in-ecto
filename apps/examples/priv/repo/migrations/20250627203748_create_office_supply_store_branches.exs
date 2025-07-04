defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreBranches do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_branches) do
      add :name, :string

      timestamps()
    end
  end
end
