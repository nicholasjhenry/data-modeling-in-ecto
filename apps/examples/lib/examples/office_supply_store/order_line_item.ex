defmodule Examples.OfficeSupplyStore.OrderLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_order_line_items" do
    field :quantity, :integer
    field :price, :decimal
    field :order_id, :id

    timestamps()
  end

  @doc false
  def changeset(order_line_item, attrs) do
    order_line_item
    |> cast(attrs, [:quantity, :price])
    |> validate_required([:quantity, :price])
  end
end
