defmodule Examples.Repo.Migrations.CreateOfficeSupplyStoreOrganizations do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_organizations) do
      add(:name, :string)
      add(:government_id, :string)
      add(:telephone_number, :string)
      add(:state, :string)

      timestamps()
    end
  end
end
