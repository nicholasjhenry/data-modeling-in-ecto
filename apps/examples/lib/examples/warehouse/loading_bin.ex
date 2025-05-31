defmodule Examples.Warehouse.LoadingBin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "warehouse_loading_bins" do
    field :size, :decimal
    field :acceptable_temperature_range, :string
    field :state, Ecto.Enum, values: [:empty, :full]
    field :designation, Ecto.Enum, values: [:food, :toxic_materials, :goods]
    field :loading_area_id, :id

    timestamps()
  end

  @doc false
  def changeset(loading_bin, attrs) do
    loading_bin
    |> cast(attrs, [:size, :acceptable_temperature_range, :state, :designation])
    |> validate_required([:size, :acceptable_temperature_range, :state, :designation])
  end
end
