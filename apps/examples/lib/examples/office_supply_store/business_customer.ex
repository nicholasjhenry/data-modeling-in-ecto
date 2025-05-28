defmodule Examples.OfficeSupplyStore.BusinessCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_business_customers" do
    field :registered_on, :date
    field :organization_id, :id

    timestamps()
  end

  @doc false
  def changeset(business_customer, attrs) do
    business_customer
    |> cast(attrs, [:registered_on])
    |> validate_required([:registered_on])
  end
end
