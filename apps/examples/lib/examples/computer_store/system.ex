defmodule Examples.ComputerStore.System do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.ComputerStore.Component

  schema "computer_store_systems" do
    field :type, Ecto.Enum, values: [:server, :workstation]
    field :price, :decimal
    field :weight, :decimal
    field :electrical_requirements, Ecto.Enum, values: [:domestic, :overseas]
    field :approval_state, Ecto.Enum, values: [:pending, :in_progress, :completed, :rescinded]

    has_many :components, Component, on_replace: :nilify

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:type, :price, :weight, :electrical_requirements, :approval_state])
    |> validate_required([:type, :price, :weight, :electrical_requirements, :approval_state])
  end

  @doc false
  def approval_completed_changeset(system) do
    change(system, %{approval_state: :completed})
  end

  # SECTION: Assoc changesets

  @doc false
  def put_component_changeset(system, component) do
    changeset = change(system)
    components = get_assoc(changeset, :components, :struct)
    components = [component | components]

    changeset
    |> put_assoc(:components, components)
    |> validate_put_component(components)
    |> Component.validate_put_system(component)
  end

  @doc false
  def remove_component_changeset(system, component) do
    changeset = change(system)
    components = get_assoc(changeset, :components, :struct)
    components = Enum.reject(components, &(&1.id == component.id))

    system
    |> change
    |> put_assoc(:components, components)
    |> validate_remove_component(components)
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_component(changeset, components) do
    changeset
    |> validate_must_have_at_least_one_component(components)
    |> validate_price_within_maximum(components)
    |> validate_weight_within_maximum(components)
    |> validate_approval_state(components)
  end

  @doc false
  def validate_remove_component(changeset, components) do
    changeset
    |> validate_must_have_at_least_one_component(components)
    |> validate_approval_state(components)
  end

  @doc false
  def validate_must_have_at_least_one_component(changeset, components) do
    if Enum.count(components) == 0 do
      add_error(changeset, :business_rule, "System must have at least one component")
    else
      changeset
    end
  end

  @doc false
  def validate_price_within_maximum(changeset, components) do
    total_component_price =
      Enum.reduce(components, Decimal.new(0), fn component, acc ->
        Decimal.add(component.price, acc)
      end)

    system_price = get_field(changeset, :price)

    if system_price <= total_component_price do
      add_error(changeset, :business_rule, "Price exceeds maximum")
    else
      changeset
    end
  end

  @doc false
  def validate_weight_within_maximum(changeset, components) do
    total_component_weight =
      Enum.reduce(components, Decimal.new(0), fn component, acc ->
        Decimal.add(component.weight, acc)
      end)

    system_weight = get_field(changeset, :weight)

    if system_weight <= total_component_weight do
      add_error(changeset, :business_rule, "Weight exceeds maximum")
    else
      changeset
    end
  end

  def validate_approval_state(changeset, _components) do
    approval_state = get_field(changeset, :approval_state)

    if approval_state == :completed do
      add_error(changeset, :business_rule, "System is approved; cannot add or remove a component")
    else
      changeset
    end
  end
end
