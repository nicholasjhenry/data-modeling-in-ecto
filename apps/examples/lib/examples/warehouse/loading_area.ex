defmodule Examples.Warehouse.LoadingArea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "warehouse_loading_areas" do
    field :type, Ecto.Enum, values: [:room_temperature, :refrigerated, :freezing]
    field :size, :decimal
    field :average_temperature, :decimal
    field :state, Ecto.Enum, values: [:static, :receiving]

    timestamps()
  end

  @doc false
  def changeset(loading_area, attrs) do
    loading_area
    |> cast(attrs, [:type, :size, :average_temperature, :state])
    |> validate_required([:type, :size, :average_temperature, :state])
  end
end
