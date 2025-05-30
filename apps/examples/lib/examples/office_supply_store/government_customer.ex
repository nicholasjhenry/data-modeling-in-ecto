defmodule Examples.OfficeSupplyStore.GovernmentCustomer do
  use Examples, :record

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
    |> validate_assoc(:organization, &validate_organization(&2, &1))
  end

  defp validate_organization(changeset, organization) do
    changeset
    |> validate_organization_multiplicity(organization)
    |> validate_organization_fields(organization)
  end

  defp validate_organization_multiplicity(changeset, organization) do
    if match?(%BusinessCustomer{}, organization.business_customer) do
      add_error(changeset, :business_rule, "Business Customer is already assigned")
    else
      changeset
    end
  end

  defp validate_organization_fields(changeset, organization) do
    if organization.government_id == nil do
      add_error(changeset, :business_rule, "Government ID is required")
    else
      changeset
    end
  end
end
