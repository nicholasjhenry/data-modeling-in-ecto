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
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end

  def put_order_line_item_changeset(changeset, order) do
    put_assoc(changeset, :order_line_item, find_order_line_item(changeset, order))
  end

  defp find_order_line_item(changeset, order) do
    order_line_item_id = changeset.params["order_line_item_id"]
    Enum.find(order.line_items, &(&1.id == order_line_item_id))
  end
end
