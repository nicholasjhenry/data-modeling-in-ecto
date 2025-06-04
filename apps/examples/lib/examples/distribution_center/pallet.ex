defmodule Examples.DistributionCenter.Pallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "distribution_center_pallets" do
    field :type, Ecto.Enum, values: [:refrigerated, :non_refrigerated]
    field :max_cases, :integer
    field :max_weight, :decimal
    field :scheduled_to_load_at, :naive_datetime
    field :state, Ecto.Enum, values: [:pending, :loaded]

    timestamps()
  end

  @doc false
  def changeset(pallet, attrs) do
    pallet
    |> cast(attrs, [:type, :max_cases, :max_weight, :scheduled_to_load_at, :state])
    |> validate_required([:type, :max_cases, :max_weight, :scheduled_to_load_at, :state])
  end
end
