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
end
