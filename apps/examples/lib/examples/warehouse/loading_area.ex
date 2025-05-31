defmodule Examples.Warehouse.LoadingArea do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.Warehouse.LoadingBin

  schema "warehouse_loading_areas" do
    field :type, Ecto.Enum, values: [:room_temperature, :refrigerated, :freezing]
    field :size, :decimal, default: Decimal.new(0)
    field :average_temperature, :decimal, default: Decimal.new("20")
    field :state, Ecto.Enum, values: [:static, :receiving]

    has_many :loading_bins, LoadingBin

    timestamps()
  end

  @doc false
  def changeset(loading_area, attrs) do
    loading_area
    |> cast(attrs, [:type, :size, :average_temperature, :state])
    |> validate_required([:type, :size, :average_temperature, :state])
  end

  @doc false
  def put_loading_bin_changeset(changeset, loading_bin) do
    loading_bins = get_assoc(changeset, :loading_bins, :struct)
    loading_bins = [loading_bin | loading_bins]
    loading_area = apply_changes(changeset)

    changeset
    |> put_assoc(:loading_bins, loading_bins)
    |> validate_loading_bin_cardinality(loading_area, loading_bins)
    |> validate_loading_bin_fields(loading_area, loading_bins)
    |> LoadingBin.validate_add_loading_area(loading_area, loading_bin)
  end

  @doc false
  def validate_add_loading_bin(changeset, loading_area, loading_bin) do
    loading_bins = [loading_bin | loading_area.loading_bins]

    changeset
    |> validate_loading_bin_cardinality(loading_area, loading_bins)
    |> validate_loading_bin_fields(loading_area, loading_bins)
  end

  @doc false
  def validate_removing_loading_bin(loading_area, loading_bin_changeset) do
    loading_bins =
      Enum.reject(
        loading_area.loading_bins,
        &(&1.id == get_field(loading_bin_changeset, :id))
      )

    validate_loading_bin_cardinality(loading_bin_changeset, loading_area, loading_bins)
  end

  @doc false
  def validate_loading_bin_cardinality(changeset, _loading_area, loading_bins) do
    if Enum.empty?(loading_bins) do
      add_error(changeset, :business_rule, "Loading area requires at least one loading bin")
    else
      changeset
    end
  end

  @doc false
  def validate_loading_bin_fields(changeset, loading_area, loading_bins) do
    required_size = Enum.reduce(loading_bins, Decimal.new(0), &Decimal.add(&2, &1.size))

    if Decimal.compare(loading_area.size, required_size) == :lt do
      add_error(changeset, :business_rule, "Loading area size is too small")
    else
      changeset
    end
  end
end
