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
    |> validate_put_organization(organization)
  end

  defp validate_put_organization(changeset, organization) do
    changeset
    # Business Rule: Type (enforced by Ecto)
    # Business Rule: Cardinality
    # Business Rule: Fields
    |> validate_organization_fields(organization)
    # Business Rule: State
    |> validate_organization_active(organization)
    # Business Rule: Conflict
    |> validate_organization_conflict(organization)
  end

  defp validate_organization_fields(changeset, organization) do
    if organization.government_id == nil do
      add_error(changeset, :business_rule, "Government ID is required")
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

  defp validate_organization_conflict(changeset, organization) do
    if match?(%BusinessCustomer{}, organization.business_customer) do
      add_error(changeset, :business_rule, "Business Customer is already assigned")
    else
      changeset
    end
  end
end
