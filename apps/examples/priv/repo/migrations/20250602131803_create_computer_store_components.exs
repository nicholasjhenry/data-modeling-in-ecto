defmodule Examples.Repo.Migrations.CreateComputerStoreComponents do
  use Ecto.Migration

  def change do
    create table(:computer_store_components) do
      add :system_type, :string
      add :price, :decimal
      add :weight, :decimal
      add :electrical_requirements, :string
      add :approval_state, :string
      add :system_id, references(:computer_store_systems, on_delete: :nothing)

      timestamps()
    end

    create index(:computer_store_components, [:system_id])
  end
end
