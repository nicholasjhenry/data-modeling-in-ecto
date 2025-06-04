defmodule Examples.Repo.Migrations.CreateDistributionCenterCases do
  use Ecto.Migration

  def change do
    create table(:distribution_center_cases) do
      add :pallet_requirement, :string
      add :weight, :decimal
      add :service_type, :string
      add :state, :string
      add :type, :string
      add :pallet_id, references(:distribution_center_pallets, on_delete: :nothing)

      timestamps()
    end

    create index(:distribution_center_cases, [:pallet_id])
  end
end
