defmodule Examples.OfficeSupplyStore.GovernmentCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_government_customers" do
    field :registered_on, :date
    field :organization_id, :id

    timestamps()
  end

  @doc false
  def changeset(government_customer, attrs) do
    government_customer
    |> cast(attrs, [:registered_on])
    |> validate_required([:registered_on])
  end
end
