defmodule Examples.OfficeSupplyStore.BusinessCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.Organization
  alias Examples.OfficeSupplyStore.GovernmentCustomer

  schema "office_supply_store_business_customers" do
    field :registered_on, :date

    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(business_customer, attrs) do
    business_customer
    |> cast(attrs, [:registered_on])
    |> validate_required([:registered_on])
  end

  @doc false
  def put_organization_changeset(business_customer, organization) do
    business_customer
    |> put_assoc(:organization, organization)
    |> validate_organization_assoc()
  end

  defp validate_organization_assoc(changeset) do
    organization = get_assoc(changeset, :organization, :struct)

    if match?(%GovernmentCustomer{}, organization.government_customer) do
      add_error(
        changeset,
        :organization,
        "cannot be assigned the role of Business Customer because it already holds the role of Government Customer"
      )
    else
      changeset
    end
  end
end
