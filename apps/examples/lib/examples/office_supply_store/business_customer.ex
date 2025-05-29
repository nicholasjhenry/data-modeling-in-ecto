defmodule Examples.OfficeSupplyStore.BusinessCustomer do
  use Examples, :record

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
    |> validate_assoc(:organization, &validate_organization/1)
  end

  defp validate_organization(changeset) do
    changeset
    |> validate_organization_multiplicity()
    |> validate_organization_fields()
  end

  def validate_organization_multiplicity(changeset) do
    if match?(%GovernmentCustomer{}, changeset.data.government_customer) do
      add_error(changeset, :government_customer, "is already assigned")
    else
      changeset
    end
  end

  def validate_organization_fields(changeset) do
    validate_required(changeset, :telephone_number, message: "is required")
  end
end
