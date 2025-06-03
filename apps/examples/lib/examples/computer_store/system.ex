defmodule Examples.ComputerStore.System do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.ComputerStore.Component

  schema "computer_store_systems" do
    field :type, Ecto.Enum, values: [:server, :workstation]
    field :price, :decimal
    field :weight, :decimal
    field :electrical_requirements, Ecto.Enum, values: [:domestic, :overseas]
    field :approval_state, Ecto.Enum, values: [:pending, :in_progress, :complete, :rescinded]

    has_many :components, Component, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:type, :price, :weight, :electrical_requirements, :approval_state])
    |> validate_required([:type, :price, :weight, :electrical_requirements, :approval_state])
  end

  # SECTION: Assoc changesets

  @doc false
  def put_component_changeset(system, component) do
    changeset = change(system)
    components = get_assoc(changeset, :components, :struct)
    components = [component | components]

    changeset
    |> put_assoc(:components, components)
    |> Component.validate_put_system(component)
    |> validate_put_component(components)
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
  end

  @doc false
  def validate_remove_component(changeset, components) do
    changeset
    |> validate_must_have_at_least_one_component(components)
  end

  @doc false
  def validate_must_have_at_least_one_component(changeset, components) do
    if Enum.count(components) == 0 do
      add_error(changeset, :business_rule, "System must have at least one component")
    else
      changeset
    end
  end
end
