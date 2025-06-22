defmodule Examples.Repo.Migrations.AddResourceRelatedFieldsToResourceHolds do
  use Ecto.Migration

  def change do
    alter table(:public_library_resource_holds) do
      add :payment, :decimal, null: false
    end
  end
end
