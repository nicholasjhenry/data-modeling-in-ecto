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
    |> cast_line_items_assoc()
    |> validate_put_line_items()
  end

  defp cast_line_items_assoc(changeset) do
    order = changeset.data.order

    line_item_changesets =
      changeset.params["line_items"]
      |> Enum.map(fn attrs ->
        %DeliveryLineItem{}
        |> DeliveryLineItem.changeset(attrs)
        |> DeliveryLineItem.put_order_line_item_changeset(order)
      end)
      |> Enum.concat(Enum.map(changeset.data.line_items, &change/1))

    put_assoc(changeset, :line_items, line_item_changesets)
  end

  defp validate_put_line_items(changeset) do
    delivery_quantities = sum_quantities(changeset)

    if Enum.any?(delivery_quantities, &quantity_exceeded?/1) do
      add_error(
        changeset,
        :business_rule,
        "Delivery line items must not exceed the quantity of the order line item"
      )
    else
      changeset
    end
  end

  defp quantity_exceeded?({_order_line_item_id, order_line_item}) do
    order_line_item.quantity_delivered > order_line_item.quantity
  end

  defp sum_quantities(changeset) do
    changeset.data.order.deliveries
    |> Enum.flat_map(& &1.line_items)
    |> Enum.concat(get_assoc(changeset, :line_items, :struct))
    |> Enum.reduce(%{}, fn
      %{order_line_item: nil} = _delivery_line_item, acc ->
        acc

      %{order_line_item: order_line_item} = delivery_line_item, acc ->
        Map.update(
          acc,
          delivery_line_item.order_line_item.id,
          OrderLineItem.add_quantity_delivered(order_line_item, delivery_line_item),
          &OrderLineItem.add_quantity_delivered(&1, delivery_line_item)
        )
    end)
  end
end
