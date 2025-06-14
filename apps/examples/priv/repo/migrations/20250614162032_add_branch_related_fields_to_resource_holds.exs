defmodule Examples.Repo.Migrations.AddBranchRelatedFieldsToResourceHolds do
  use Ecto.Migration

  def change do
    alter table(:public_library_resource_holds) do
      add :pickup_day, :string, null: false
    end
  end
end
