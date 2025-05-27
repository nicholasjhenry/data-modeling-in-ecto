defmodule Examples.OfficeSupplyStore.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_organizations" do
    field(:name, :string)
    field(:government_id, :string)
    field(:telephone_number, :string)
    field(:state, Ecto.Enum, values: [:active, :inactive, :closed])

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :government_id, :telephone_number, :state])
    |> validate_required([:name, :government_id, :telephone_number, :state])
  end
end
