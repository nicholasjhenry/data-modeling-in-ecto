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

  # SECTION: Assoc Action Changesets

  @doc false
  def put_loading_area_changeset(loading_area, loading_bin) do
    loading_bin
    |> change
    |> put_assoc(:loading_area, loading_area)
    |> validate_put_loading_area(loading_area, loading_bin)
    |> LoadingArea.validate_put_loading_bin(loading_area, loading_bin)
  end

  @doc false
  def remove_loading_bin_changeset(loading_bin, loading_area) do
    loading_bin
    |> change
    |> put_change(:loading_area, nil)
    |> validate_remove_loading_area(loading_area, loading_bin)
    |> LoadingArea.validate_remove_loading_bin(loading_area, loading_bin)
  end

  # SECTION: Assoc Action Validations

  @doc false
  def validate_put_loading_area(changeset, loading_area, loading_bin) do
    changeset
    |> validate_loading_area_fields(loading_area, loading_bin)
    |> validate_loading_area_type(loading_area, loading_bin)
  end

  @doc false
  def validate_remove_loading_area(changeset, _loading_area, _loading_bin) do
    changeset
  end

  # SECTION: Assoc Business Rules

  @doc false
  def validate_loading_area_type(changeset, _loading_area, _loading_bin) do
    # loading bin knows the types of loading areas—room temperature, refrigerated, or freezing—that can house in

    changeset
  end

  @doc false
  def validate_loading_area_cardinality(changeset, _loading_area, _loading_bin) do
    # loading bin is always within one loading area, being moved between loading areas, or not in use

    changeset
  end

  @doc false
  def validate_loading_area_fields(changeset, loading_area, loading_bin) do
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
end
