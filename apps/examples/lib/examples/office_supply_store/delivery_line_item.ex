defmodule Examples.OfficeSupplyStore.DeliveryLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_delivery_line_items" do
    field :quantity, :integer
    field :delivery_id, :id
    field :order_line_item_id, :id

    timestamps()
  end

  @doc false
  def changeset(delivery_line_item, attrs) do
    delivery_line_item
    |> cast(attrs, [:order_line_item_id, :quantity])
    |> validate_required([:order_line_item_id, :quantity])
  end
end
