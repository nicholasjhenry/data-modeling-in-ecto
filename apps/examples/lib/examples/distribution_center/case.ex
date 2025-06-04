defmodule Examples.DistributionCenter.Case do
  use Ecto.Schema
  import Ecto.Changeset

  schema "distribution_center_cases" do
    field :pallet_type, Ecto.Enum, values: [:refrigerated, :non_refrigerated]
    field :weight, :decimal
    field :service_type, Ecto.Enum, values: [:regular, :rushed]
    field :state, Ecto.Enum, values: [:empty, :full, :damaged, :defective, :expired]
    field :pallet_id, :id

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(case, attrs) do
    case
    |> cast(attrs, [:pallet_type, :weight, :service_type, :state])
    |> validate_required([:pallet_type, :weight, :service_type, :state])
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_pallet(pallet_changeset, _case) do
    pallet_changeset
  end
end
