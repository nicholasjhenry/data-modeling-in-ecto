defmodule Examples.PublicLibrary.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_branches" do
    field :name, :string

    field :permitted_resource_holds_types, {:array, :string},
      default: ["open_ended", "closed_ended"]

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
    |> cast(attrs, [
      :name,
      :permitted_resource_holds_types,
      :business_days,
      :state,
      :permitted_patron_roles_for_resource_holds
    ])
    |> validate_required([:name])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, branch) do
    resource_hold_changeset
    |> validate_resource_hold_type_permitted(branch)
    |> validate_resource_hold_pickup_day(branch)
  end

  defp validate_resource_hold_type_permitted(resource_hold_changeset, branch) do
    resource_hold_type = get_field(resource_hold_changeset, :type)

    if to_string(resource_hold_type) not in branch.permitted_resource_holds_types do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This branch does not permit open-ended holds"
      )
    else
      resource_hold_changeset
    end
  end

  defp validate_resource_hold_pickup_day(resource_hold_changeset, branch) do
    resource_hold_pickup_day = get_field(resource_hold_changeset, :pickup_day)

    if resource_hold_pickup_day not in branch.business_days do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This branch does not permit pickup on the selected day"
      )
    else
      resource_hold_changeset
    end
  end
end
