defmodule Examples.OfficeSupplyStore.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.Order

  schema "office_supply_store_deliveries" do
    field :type, Ecto.Enum, values: [:partial, :complete], default: :partial
    field :state, Ecto.Enum, values: [:pending, :completed, :cancelled], default: :pending
    field :address, :string

    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:type, :state, :address])
    |> validate_required([:type, :state, :address])
  end

  def put_order_changeset(delivery, order) do
    delivery
    |> put_assoc(:order, order)
    |> Order.validate_put_delivery(order)
  end
end
