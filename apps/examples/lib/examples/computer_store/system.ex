defmodule Examples.ComputerStore.System do
  use Ecto.Schema
  import Ecto.Changeset

  schema "computer_store_systems" do
    field :type, Ecto.Enum, values: [:server, :workstation]
    field :price, :decimal
    field :weight, :decimal
    field :electrical_requirements, Ecto.Enum, values: [:domestic, :overseas]
    field :approval_state, Ecto.Enum, values: [:pending, :in_progress, :complete, :rescinded]

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:type, :price, :weight, :electrical_requirements, :approval_state])
    |> validate_required([:type, :price, :weight, :electrical_requirements, :approval_state])
  end
end
