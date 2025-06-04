defmodule Examples.DistributionCenter.Pallet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.DistributionCenter.Case

  schema "distribution_center_pallets" do
    field :type, Ecto.Enum, values: [:refrigerated, :non_refrigerated]
    field :max_cases, :integer
    field :max_weight, :decimal
    field :scheduled_to_load_at, :naive_datetime
    field :state, Ecto.Enum, values: [:pending, :loaded]

    has_many :cases, Case

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(pallet, attrs) do
    pallet
    |> cast(attrs, [:type, :max_cases, :max_weight, :scheduled_to_load_at, :state])
    |> validate_required([:type, :max_cases, :max_weight, :scheduled_to_load_at, :state])
  end

  # SECTION: Assoc changesets

  @doc false
  def put_case_changeset(pallet_or_changeset, case) do
    changeset = change(pallet_or_changeset)
    cases = get_assoc(changeset, :cases, :struct)
    cases = [case | cases]

    changeset
    |> put_assoc(:cases, cases)
    |> validate_put_case(cases)
    |> Case.validate_put_pallet(case)
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_case(changeset, _cases) do
    changeset
  end
end
