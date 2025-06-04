defmodule Examples.DistributionCenter.Case do
  use Ecto.Schema
  import Ecto.Changeset

  schema "distribution_center_cases" do
    field :pallet_requirement, Ecto.Enum,
      values: [:refrigerated, :non_refrigerated],
      default: :non_refrigerated

    field :weight, :decimal
    field :service_type, Ecto.Enum, values: [:regular, :rush], default: :regular

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
  def validate_put_pallet(pallet_changeset, case, opts \\ []) do
    current_date_time = Keyword.get(opts, :current_date_time, DateTime.utc_now())

    pallet_changeset
    |> validate_type(case)
    |> validate_cardinality(case)
    |> validate_service_type(case, current_date_time)
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

  defp validate_service_type(pallet_changeset, %{service_type: :rush}, current_date_time) do
    scheduled_to_load_at = get_field(pallet_changeset, :scheduled_to_load_at)

    if DateTime.diff(scheduled_to_load_at, current_date_time, :hour) > 24 do
      add_error(pallet_changeset, :business_rule, "Pallet does not meet case's sevice requirment")
    else
      pallet_changeset
    end
  end

  defp validate_service_type(pallet_changeset, _case, _current_date_time) do
    pallet_changeset
  end
end
