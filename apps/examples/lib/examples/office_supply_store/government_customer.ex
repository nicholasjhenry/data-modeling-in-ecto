defmodule Examples.OfficeSupplyStore.GovernmentCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.BusinessCustomer
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
    |> validate_organization_assoc()
  end

  defp validate_organization_assoc(changeset) do
    organization = get_assoc(changeset, :organization, :struct)

    if match?(%BusinessCustomer{}, organization.business_customer) do
      add_error(
        changeset,
        :organization,
        "cannot be assigned the role of Government Customer because it already holds the role of Business Customer"
      )
    else
      changeset
    end
  end
end
