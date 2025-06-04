defmodule Examples.Repo.Migrations.CreateComputerStoreSystems do
  use Ecto.Migration

  def change do
    create table(:computer_store_systems) do
      add :type, :string
      add :price, :decimal
      add :weight, :decimal
      add :electrical_requirements, :string
      add :approval_state, :string

      timestamps()
    end
  end
end
