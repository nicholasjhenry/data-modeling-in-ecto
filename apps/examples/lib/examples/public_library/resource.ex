defmodule Examples.PublicLibrary.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_resources" do
    field :type, Ecto.Enum, values: [:normal, :restricted], default: :normal

    field :state, Ecto.Enum,
      values: [:available, :on_hold, :damaged, :defective],
      default: :available

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

  @doc false
  def on_hold_state_changeset(resource) do
    change(resource, state: :on_hold)
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, resource) do
    resource_hold_changeset
    |> validate_resource_hold_type(resource)
    |> validate_resource_hold_payment(resource)
    |> validate_resource_state_for_resource_hold(resource)
  end

  defp validate_resource_hold_type(resource_hold_changeset, resource) do
    resource_hold_type = get_field(resource_hold_changeset, :type)

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

  defp validate_resource_hold_payment(resource_hold_changeset, resource) do
    resource_hold_payment = get_field(resource_hold_changeset, :payment)

    if Decimal.compare(resource_hold_payment, resource.retrieval_fee) not in [:eq, :gt] do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This resource hold does not have an adequate payment"
      )
    else
      resource_hold_changeset
    end
  end

  defp validate_resource_state_for_resource_hold(resource_hold_changeset, resource) do
    if resource.state != :available do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This resource is not available"
      )
    else
      resource_hold_changeset
    end
  end

  @doc false
  def validate_put_resource_hold_conflict(resource_hold_changeset) do
    resource = get_assoc(resource_hold_changeset, :resource, :struct)
    patron = get_assoc(resource_hold_changeset, :patron, :struct)

    if resource != nil and patron != nil do
      validate_resource_type_and_patron_type_for_resource_hold(
        resource_hold_changeset,
        resource,
        patron
      )
    else
      resource_hold_changeset
    end
  end

  defp validate_resource_type_and_patron_type_for_resource_hold(
         resource_hold_changeset,
         resource,
         patron
       ) do
    if resource.type == :restricted and patron.type != :researcher do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "This resource is restricted"
      )
    else
      resource_hold_changeset
    end
  end
end
