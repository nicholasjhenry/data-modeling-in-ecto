defmodule Examples.Warehouse.LoadingArea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "warehouse_loading_areas" do
    field :type, Ecto.Enum, values: [:room_temperature, :refrigerated, :freezing]
    field :size, :decimal
    field :average_temperature, :decimal
    field :state, Ecto.Enum, values: [:static, :receiving]

    has_many :loading_bins, Examples.Warehouse.LoadingBin

    timestamps()
  end

  @doc false
  def changeset(loading_area, attrs) do
    loading_area
    |> cast(attrs, [:type, :size, :average_temperature, :state])
    |> validate_required([:type, :size, :average_temperature, :state])
  end

  @doc false
  def put_loading_bin(loading_area, loading_bin) do
    loading_bins = get_assoc(loading_area, :loading_bins, :struct)

    loading_area
    |> put_assoc(:loading_bins, [loading_bin | loading_bins])
    |> validate_cardinality()
  end

  @doc false
  def validate_cardinality(changeset) do
    loading_bins = get_assoc(changeset, :loading_bins, :struct)

    if Enum.empty?(loading_bins) do
      add_error(changeset, :business_rule, "Loading area requires at least one loading bin")
    else
      changeset
    end
  end
end
