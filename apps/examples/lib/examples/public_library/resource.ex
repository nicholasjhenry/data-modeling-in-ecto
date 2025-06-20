defmodule Examples.PublicLibrary.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_resources" do
    field :type, Ecto.Enum, values: [:normal, :restricted], default: :normal
    field :state, Ecto.Enum, values: [:available, :damaged, :defective], default: :available
    field :retrieval_fee, :decimal, default: Decimal.new(0)

    field :permitted_resource_hold_types, {:array, :string},
      default: ["open_ended", "closed_ended"]

    timestamps()
  end

  # SECTION: Queries
  #
  def has_fee?(resource) do
    !Decimal.equal?(resource.retrieval_fee, Decimal.new(0))
  end

  # SECTION: Field changesets

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:type, :state, :retrieval_fee, :permitted_resource_hold_types])
    |> validate_required([:type, :state, :retrieval_fee, :permitted_resource_hold_types])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, resource) do
    resource_hold_type = get_field(resource_hold_changeset, :type) |> dbg

    if to_string(resource_hold_type) not in resource.permitted_resource_hold_types do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This resource does not permit the resource hold type"
      )
    else
      resource_hold_changeset
    end
  end
end
