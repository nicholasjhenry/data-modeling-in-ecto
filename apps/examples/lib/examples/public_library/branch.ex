defmodule Examples.PublicLibrary.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_branches" do
    field :name, :string
    field :permitted_resource_holds, {:array, :string}, default: ["open", "closed"]

    field :business_days, {:array, :string},
      default: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    field :state, Ecto.Enum, values: [:normal, :reviewing_inventory], default: :normal

    field :permitted_patron_roles_for_resource_holds, {:array, :string},
      default: ["regular", "researcher"]

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, _branch) do
    resource_hold_changeset
  end
end
