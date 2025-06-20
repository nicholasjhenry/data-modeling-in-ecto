defmodule Examples.Repo.Migrations.AddResourceHoldRelatedFieldsToResources do
  use Ecto.Migration

  def change do
    alter table(:public_library_resources) do
      remove :has_fee, :boolean
      add :type, :string, null: false
      add :state, :string, null: false
      add :permitted_resource_hold_types, {:array, :string}, null: false
      add :retrieval_fee, :decimal, null: false
    end
  end
end
