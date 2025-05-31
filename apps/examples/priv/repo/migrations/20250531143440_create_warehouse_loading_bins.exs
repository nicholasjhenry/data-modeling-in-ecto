defmodule Examples.Repo.Migrations.CreateWarehouseLoadingBins do
  use Ecto.Migration

  def change do
    create table(:warehouse_loading_bins) do
      add :size, :decimal
      add :acceptable_temperature_range, :numrange
      add :state, :string
      add :designation, :string
      add :loading_area_id, references(:warehouse_loading_areas, on_delete: :nothing)

      timestamps()
    end

    create index(:warehouse_loading_bins, [:loading_area_id])
  end
end
