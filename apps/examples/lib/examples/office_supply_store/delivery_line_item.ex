defmodule Examples.OfficeSupplyStore.DeliveryLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.OrderLineItem

  schema "office_supply_store_delivery_line_items" do
    field :quantity, :integer
    field :delivery_id, :id

    belongs_to :order_line_item, OrderLineItem

    timestamps()
  end

  @doc false
  def changeset(delivery_line_item, attrs) do
    delivery_line_item
    |> cast(attrs, [:order_line_item_id, :quantity])
    |> validate_required([:order_line_item_id, :quantity])
  end
end
