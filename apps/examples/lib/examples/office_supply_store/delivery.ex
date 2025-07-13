defmodule Examples.OfficeSupplyStore.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.DeliveryLineItem
  alias Examples.OfficeSupplyStore.Order
  alias Examples.OfficeSupplyStore.OrderLineItem

  schema "office_supply_store_deliveries" do
    field :type, Ecto.Enum, values: [:partial, :complete], default: :partial
    field :state, Ecto.Enum, values: [:pending, :completed, :cancelled], default: :pending
    field :address, :string

    belongs_to :order, Order
    has_many :line_items, DeliveryLineItem

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

  def put_line_item_changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [])
    |> cast_assoc(:line_items)
    |> validate_put_line_items()
  end

  defp validate_put_line_items(changeset) do
    order_line_items = put_quantity_delivered(changeset)

    if Enum.any?(order_line_items, &quantity_exceeded?/1) do
      add_error(
        changeset,
        :business_rule,
        "Delivery line items must not exceed the quantity of the order line item"
      )
    else
      changeset
    end
  end

  defp quantity_exceeded?(order_line_item) do
    order_line_item.quantity_delivered > order_line_item.quantity
  end

  defp put_quantity_delivered(changeset) do
    order_line_items = changeset.data.order.line_items
    new_delivery_line_items = get_assoc(changeset, :line_items, :struct)

    delivery_line_items =
      changeset.data.order.deliveries
      |> Enum.flat_map(& &1.line_items)
      |> Enum.concat(new_delivery_line_items)

    delivery_line_items
    |> Enum.filter(&(&1.order_line_item_id != nil))
    |> Enum.reduce(%{}, fn delivery_line_item, acc ->
      order_line_item =
        Enum.find(order_line_items, &(&1.id == delivery_line_item.order_line_item_id))

      Map.update(
        acc,
        order_line_item.id,
        OrderLineItem.add_quantity_delivered(order_line_item, delivery_line_item),
        &OrderLineItem.add_quantity_delivered(&1, delivery_line_item)
      )
    end)
    |> Map.values()
  end
end
