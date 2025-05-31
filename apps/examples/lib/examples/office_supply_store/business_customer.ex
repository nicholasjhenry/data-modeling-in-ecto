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
    |> validate_put_organization(organization)
  end

  defp validate_put_organization(changeset, organization) do
    changeset
    |> validate_organization_fields(organization)
    |> validate_organization_active(organization)
    |> validate_organization_conflict(organization)
  end

  def validate_organization_fields(changeset, organization) do
    if organization.telephone_number == nil do
      add_error(changeset, :business_rule, "Telephone number is required")
    else
      changeset
    end
  end

  def validate_organization_active(changeset, organization) do
    if !Organization.active?(organization) do
      add_error(changeset, :business_rule, "Organization is not active")
    else
      changeset
    end
  end

  def validate_organization_conflict(changeset, organization) do
    if match?(%GovernmentCustomer{}, organization.government_customer) do
      add_error(changeset, :business_rule, "Government customer is already assigned")
    else
      changeset
    end
  end
end
