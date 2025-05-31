defmodule Examples.Warehouse.LoadingBin do
  use Examples, :record

  alias Examples.Warehouse.LoadingArea

  schema "warehouse_loading_bins" do
    field :size, :decimal
    field :acceptable_temperature_range, :string
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
  def add_loading_bin_changeset(loading_bin, loading_area) do
    changeset =
      loading_bin
      |> change
      |> put_assoc(:loading_area, loading_area)

    LoadingArea.validate_add_loading_bin(loading_area, changeset)
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
