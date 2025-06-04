defmodule Examples.Repo.Migrations.CreateDistributionCenterPallets do
  use Ecto.Migration

  def change do
    create table(:distribution_center_pallets) do
      add :type, :string
      add :max_cases, :integer
      add :max_weight, :decimal
      add :scheduled_to_load_at, :naive_datetime
      add :state, :string

      timestamps()
    end
  end
end
