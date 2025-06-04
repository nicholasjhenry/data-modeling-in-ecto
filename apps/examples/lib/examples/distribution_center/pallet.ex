defmodule Examples.DistributionCenter.Pallet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.DistributionCenter.Case

  schema "distribution_center_pallets" do
    field :type, Ecto.Enum, values: [:refrigerated, :non_refrigerated], default: :non_refrigerated
    field :max_weight, :decimal
    field :scheduled_to_load_at, :naive_datetime
    field :state, Ecto.Enum, values: [:pending, :loaded], default: :pending

    # Calculations
    field :case_count, :integer, virtual: true, default: 0
    field :actual_weight, :decimal, virtual: true, default: Decimal.new(0)

    has_many :cases, Case

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(pallet, attrs) do
    pallet
    |> cast(attrs, [:type, :max_weight, :scheduled_to_load_at])
    |> validate_required([:type, :max_weight, :scheduled_to_load_at])
  end

  # SECTION: Assoc changesets

  @doc false
  def put_case_changeset(pallet_or_changeset, case, opts \\ []) do
    changeset = change(pallet_or_changeset)
    cases = get_assoc(changeset, :cases, :struct)
    cases = [case | cases]

    case_count = get_field(changeset, :case_count) + 1
    actual_weight = Decimal.add(get_field(changeset, :actual_weight), case.weight)

    changeset
    |> put_assoc(:cases, cases)
    |> put_change(:case_count, case_count)
    |> put_change(:actual_weight, actual_weight)
    |> validate_put_case(cases, opts)
    |> validate_max_weight(cases)
    |> Case.validate_put_pallet(case)
  end

  # SECTION: Calculations

  @doc false
  def calculate_case_count(pallet) do
    case_count = Enum.count(pallet.cases)

    %{pallet | case_count: case_count}
  end

  def calculate_actual_weight(pallet) do
    actual_weight =
      Enum.reduce(pallet.cases, Decimal.new(0), fn case, acc ->
        Decimal.add(acc, case.weight)
      end)

    %{pallet | actual_weight: actual_weight}
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_case(changeset, cases, opts) do
    changeset
    |> validate_case_count(cases, opts)
  end

  @default_case_count 25

  defp validate_case_count(changeset, _cases, opts) do
    max_case_count = Keyword.get(opts, :max_case_count, @default_case_count)
    case_count = get_field(changeset, :case_count)

    if case_count > max_case_count do
      add_error(changeset, :business_rule, "Pallet exceeds capacity")
    else
      changeset
    end
  end

  defp validate_max_weight(changeset, _cases) do
    max_weight = get_field(changeset, :max_weight)
    actual_weight = get_field(changeset, :actual_weight)

    if Decimal.compare(actual_weight, max_weight) == :gt do
      add_error(changeset, :business_rule, "Case weight exceeds pallet capacity")
    else
      changeset
    end
  end
end
