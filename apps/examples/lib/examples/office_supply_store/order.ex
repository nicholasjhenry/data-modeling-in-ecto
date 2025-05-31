defmodule Examples.OfficeSupplyStore.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_orders" do
    field :state, Ecto.Enum, values: [:payment_pending, :delivery_pending, :completed]

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
