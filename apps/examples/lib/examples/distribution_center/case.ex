defmodule Examples.DistributionCenter.Case do
  use Ecto.Schema
  import Ecto.Changeset

  schema "distribution_center_cases" do
    field :pallet_requirement, Ecto.Enum,
      values: [:refrigerated, :non_refrigerated],
      default: :non_refrigerated

    field :weight, :decimal
    field :service_type, Ecto.Enum, values: [:regular, :rushed], default: :regular

    field :state, Ecto.Enum,
      values: [:empty, :full, :damaged, :defective, :expired],
      default: :empty

    field :pallet_id, :id

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(case, attrs) do
    case
    |> cast(attrs, [:pallet_requirement, :weight, :service_type])
    |> validate_required([:pallet_requirement, :weight, :service_type])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_pallet(pallet_changeset, case) do
    pallet_changeset
    |> validate_type(case)
    |> validate_cardinality(case)
  end

  defp validate_type(pallet_changeset, case) do
    pallet_type = get_field(pallet_changeset, :type)

    if pallet_type != case.pallet_requirement do
      add_error(pallet_changeset, :business_rule, "Pallet type meet case requirements")
    else
      pallet_changeset
    end
  end

  defp validate_cardinality(pallet_changeset, case) do
    if case.pallet_id do
      add_error(pallet_changeset, :business_rule, "Case already assigned to a pallet")
    else
      pallet_changeset
    end
  end
end
