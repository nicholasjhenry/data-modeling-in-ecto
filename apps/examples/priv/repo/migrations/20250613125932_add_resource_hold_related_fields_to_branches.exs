defmodule Nomify.Repo.Migrations.AddResourceHoldRelatedFieldsToBranches do
  use Ecto.Migration

  def change do
    alter table(:public_library_branches) do
      add :permitted_resource_holds, {:array, :string}, null: false
      add :business_days, {:array, :string}, null: false
      add :state, :string, null: false
      add :permitted_patron_roles_for_resource_holds, {:array, :string}, null: false
    end
  end
end
