defmodule Examples.OfficeSupplyStore.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.DeliveryLineItem
  alias Examples.OfficeSupplyStore.Order

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

  def put_line_items_changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [])
    |> put_line_items_assoc()
  end

  defp put_line_items_assoc(changeset) do
    line_item_changesets =
      Enum.map(
        changeset.params["line_items"],
        &cast_line_item_assoc(&1, changeset.data.order.line_items)
      )

    put_assoc(changeset, :line_items, line_item_changesets)
  end

  defp cast_line_item_assoc(attrs, order_line_items) do
    %DeliveryLineItem{}
    |> DeliveryLineItem.changeset(attrs)
    |> DeliveryLineItem.validate_put_order_line_item_changeset(order_line_items)
  end
end
