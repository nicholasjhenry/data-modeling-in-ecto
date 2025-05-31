defmodule Examples.Warehouse.LoadingArea do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.Warehouse.LoadingBin

  schema "warehouse_loading_areas" do
    field :type, Ecto.Enum, values: [:room_temperature, :refrigerated, :freezing]
    field :size, :decimal, default: Decimal.new(0)
    field :average_temperature, :decimal, default: Decimal.new("20")
    field :state, Ecto.Enum, values: [:static, :receiving], default: :static

    has_many :loading_bins, LoadingBin

    timestamps()
  end

  @doc false
  def changeset(loading_area, attrs) do
    loading_area
    |> cast(attrs, [:type, :size, :average_temperature])
    |> validate_required([:type, :size, :average_temperature])
  end

  @doc false
  def receive_changeset(loading_area) do
    loading_area
    |> change
    |> put_change(:state, :receiving)
  end

  # SECTION: Assoc Action Changesets

  @doc false
  def put_loading_bin_changeset(changeset, loading_bin) do
    loading_bins = get_assoc(changeset, :loading_bins, :struct)
    loading_area = apply_changes(changeset)

    changeset
    |> put_assoc(:loading_bins, [loading_bin | loading_bins])
    |> validate_put_loading_bin(loading_area, loading_bin)
    |> LoadingBin.validate_put_loading_area(loading_area, loading_bin)
  end

  # SECTION: Assoc Action Validations

  @doc false
  def validate_put_loading_bin(changeset, loading_area, loading_bin) do
    loading_bins = [loading_bin | loading_area.loading_bins]

    changeset
    |> validate_at_least_one_loading_bin(loading_area, loading_bins)
    |> validate_accommodates_size(loading_area, loading_bins)
    |> validate_not_receiving(loading_area, loading_bins)
  end

  @doc false
  def validate_remove_loading_bin(changeset, loading_area, loading_bin) do
    loading_bins = Enum.reject(loading_area.loading_bins, &(&1.id == loading_bin.id))

    changeset
    |> validate_at_least_one_loading_bin(loading_area, loading_bins)
    |> validate_not_receiving(loading_area, loading_bins)
  end

  # SECTION: Assoc Business Rule Validations

  # NOTE: cardinality validation
  @doc false
  def validate_at_least_one_loading_bin(changeset, _loading_area, loading_bins) do
    if Enum.empty?(loading_bins) do
      add_error(changeset, :business_rule, "Loading area requires at least one loading bin")
    else
      changeset
    end
  end

  # NOTE: field validation
  @doc false
  def validate_accommodates_size(changeset, loading_area, loading_bins) do
    required_size = Enum.reduce(loading_bins, Decimal.new(0), &Decimal.add(&2, &1.size))

    if Decimal.compare(loading_area.size, required_size) == :lt do
      add_error(changeset, :business_rule, "Loading area size is too small")
    else
      changeset
    end
  end

  # NOTE: state validation
  @doc false
  def validate_not_receiving(changeset, loading_area, _loading_bins) do
    if loading_area.state == :receiving do
      add_error(
        changeset,
        :business_rule,
        "Cannot remove loading bins while loading area is receiving"
      )
    else
      changeset
    end
  end
end
