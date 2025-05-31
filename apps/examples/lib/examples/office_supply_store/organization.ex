defmodule Examples.OfficeSupplyStore.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.BusinessCustomer
  alias Examples.OfficeSupplyStore.GovernmentCustomer

  schema "office_supply_store_organizations" do
    field :name, :string
    field :government_id, :string
    field :telephone_number, :string
    field :state, Ecto.Enum, values: [:active, :inactive, :closed]

    has_one :business_customer, BusinessCustomer
    has_one :government_customer, GovernmentCustomer

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :government_id, :telephone_number, :state])
    |> validate_required([:name, :state])
  end

  @doc false
  def active?(organization) do
    organization.state == :active
  end
end
