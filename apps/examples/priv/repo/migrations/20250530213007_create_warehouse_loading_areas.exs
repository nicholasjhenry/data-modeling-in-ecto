defmodule Examples.Repo.Migrations.CreateWarehouseLoadingAreas do
  use Ecto.Migration

  def change do
    create table(:warehouse_loading_areas) do
      add :type, :string
      add :size, :decimal
      add :average_temperature, :decimal
      add :state, :string

      timestamps()
    end
  end
end
