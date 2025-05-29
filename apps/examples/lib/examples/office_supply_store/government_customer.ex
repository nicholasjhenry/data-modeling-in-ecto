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
    |> validate_assoc(:organization, &validate_organization/1)
  end

  defp validate_organization(changeset) do
    changeset
    |> validate_organization_multiplicity()
    |> validate_organization_fields()
  end

  defp validate_organization_multiplicity(changeset) do
    if match?(%BusinessCustomer{}, changeset.data.business_customer) do
      add_error(changeset, :business_customer, "is already assigned")
    else
      changeset
    end
  end

  defp validate_organization_fields(changeset) do
    validate_required(changeset, :government_id, message: "is required")
  end
end
