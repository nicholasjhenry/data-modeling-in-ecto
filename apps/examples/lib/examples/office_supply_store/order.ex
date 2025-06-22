defmodule Examples.OfficeSupplyStore.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.OrderLineItem

  schema "office_supply_store_orders" do
    field :state, Ecto.Enum, values: [:payment_pending, :delivery_pending, :completed]
    has_many :line_items, OrderLineItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end

  def put_line_item_changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> cast_assoc(:line_items)
  end
end
