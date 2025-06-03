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

    has_many :components, Component

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:type, :price, :weight, :electrical_requirements, :approval_state])
    |> validate_required([:type, :price, :weight, :electrical_requirements, :approval_state])
  end

  @doc false
  def put_component_changeset(changeset, component) do
    components = get_assoc(changeset, :components, :struct)

    changeset
    |> put_assoc(:components, [component | components])
    |> validate_put_component()
  end

  @doc false
  def validate_put_component(changeset) do
    components = get_assoc(changeset, :components, :struct)

    if Enum.count(components) == 0 do
      add_error(changeset, :business_rule, "system must have at least one component")
    else
      changeset
    end
  end
end
