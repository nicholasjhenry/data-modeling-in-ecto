defmodule Examples.OfficeSupplyStore.OrderLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_order_line_items" do
    field :quantity, :integer
    field :price, :decimal

    field :quantity_delivered, :integer, virtual: true, default: 0

    belongs_to :order, Examples.OfficeSupplyStore.Order
    belongs_to :product, Examples.OfficeSupplyStore.Product
    has_many :delivery_line_items, Examples.OfficeSupplyStore.DeliveryLineItem

    timestamps()
  end

  @doc false
  def changeset(order_line_item, attrs) do
    order_line_item
    |> cast(attrs, [:quantity, :price])
    |> validate_required([:quantity, :price])
  end

  def put_product_changeset(order_line_item, product) do
    put_assoc(order_line_item, :product, product)
  end

  def put_quantity_delivered(order_line_item) do
    Enum.reduce(order_line_item.delivery_line_items, order_line_item, fn delivery_line_item,
                                                                         acc ->
      put_quantity_delivered(acc, delivery_line_item)
    end)
  end

  def put_quantity_delivered(order_line_item, delivery_line_item) do
    %{
      order_line_item
      | quantity_delivered: order_line_item.quantity_delivered + delivery_line_item.quantity
    }
  end

  def quantity_exceeded?(order_line_item) do
    order_line_item.quantity_delivered > order_line_item.quantity
  end
end
