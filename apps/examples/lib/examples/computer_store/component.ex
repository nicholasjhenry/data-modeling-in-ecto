defmodule Examples.ComputerStore.Component do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.ComputerStore.System

  schema "computer_store_components" do
    field :system_type, Ecto.Enum, values: [:server, :workstation, :both]
    field :price, :decimal
    field :weight, :decimal
    field :electrical_requirements, Ecto.Enum, values: [:domestic, :overseas]
    field :approval_state, Ecto.Enum, values: [:operational, :damaged, :defective]

    belongs_to :system, System

    timestamps()
  end

  @doc false
  def changeset(component, attrs) do
    component
    |> cast(attrs, [:system_type, :price, :weight, :electrical_requirements, :approval_state])
    |> validate_required([
      :system_type,
      :price,
      :weight,
      :electrical_requirements,
      :approval_state
    ])
  end

  @doc false
  def validate_put_system(system_changeset, component) do
    system_changeset
    |> validate_system_type(component)
    |> validate_electrical_requirements(component)
  end

  @doc false
  def validate_system_type(system_changeset, component) do
    if component.system_type != :both &&
         get_field(system_changeset, :type) != component.system_type do
      add_error(
        system_changeset,
        :business_rule,
        "Invalid component type for system; they must be compatiable"
      )
    else
      system_changeset
    end
  end

  @doc false
  def validate_electrical_requirements(system_changeset, component) do
    if get_field(system_changeset, :electrical_requirements) != component.electrical_requirements do
      add_error(
        system_changeset,
        :business_rule,
        "Component and system have incompatible electrical requirements"
      )
    else
      system_changeset
    end
  end
end
