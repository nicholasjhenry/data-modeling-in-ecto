defmodule Examples.OfficeSupplyStore.GovernmentCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.Organization

  schema "office_supply_store_government_customers" do
    field :registered_on, :date
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(government_customer, attrs) do
    government_customer
    |> cast(attrs, [:registered_on])
    |> validate_required([:registered_on])
  end

  @doc false
  def put_organization_changeset(government_customer, organization) do
    government_customer
    |> put_assoc(:organization, organization)
  end
end
