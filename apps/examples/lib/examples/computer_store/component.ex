defmodule Examples.ComputerStore.Component do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.ComputerStore.System

  schema "computer_store_components" do
    field :system_type, Ecto.Enum, values: [:server, :workstation]
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
end
