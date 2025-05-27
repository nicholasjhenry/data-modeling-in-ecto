defmodule Examples.Repo.Migrations.CreateOfficeSupplyStorePeople do
  use Ecto.Migration

  def change do
    create table(:office_supply_store_people) do
      add(:name, :string)
      add(:born_at, :date)
      add(:email, :string)
      add(:telephone_number, :string)

      timestamps()
    end
  end
end
