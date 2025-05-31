defmodule Examples.Warehouse.LoadingBin do
  use Examples, :record

  alias Examples.Warehouse.LoadingArea
  alias PgRanges.NumRange

  schema "warehouse_loading_bins" do
    field :size, :decimal

    field :acceptable_temperature_range, NumRange,
      default: NumRange.new(Decimal.new("10"), Decimal.new("30"))

    field :state, Ecto.Enum, values: [:empty, :full]
    field :designation, Ecto.Enum, values: [:food, :toxic_materials, :goods]

    belongs_to :loading_area, LoadingArea, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(loading_bin, attrs) do
    loading_bin
    |> cast(attrs, [:size, :acceptable_temperature_range, :state, :designation])
    |> validate_required([:size, :acceptable_temperature_range, :state, :designation])
  end

  @doc false
  def add_loading_bin_changeset(loading_area, loading_bin) do
    loading_bin
    |> change
    |> put_assoc(:loading_area, loading_area)
    |> LoadingArea.validate_add_loading_bin(loading_area, loading_bin)
    |> validate_add_loading_area(loading_area, loading_bin)
  end

  def validate_add_loading_area(changeset, loading_area, loading_bin) do
    if not temperature_in_range?(
         loading_area.average_temperature,
         loading_bin.acceptable_temperature_range
       ) do
      add_error(
        changeset,
        :business_rule,
        "Loading area exceeds loading bins acceptable temperature range"
      )
    else
      changeset
    end
  end

  defp temperature_in_range?(temperature, range) do
    Decimal.compare(temperature, range.lower) == :gt and
      Decimal.compare(temperature, range.upper) == :lt
  end

  @doc false
  def remove_loading_bin_changeset(loading_bin, loading_area) do
    changeset = change(loading_bin)

    # changeset =
    #   validate_assoc(changeset, :loading_area, &LoadingArea.validate_remove_loading_bin/2)

    changeset = LoadingArea.validate_removing_loading_bin(loading_area, changeset)

    if changeset.valid? do
      put_change(changeset, :loading_area, nil)
    else
      changeset
    end
  end
end
