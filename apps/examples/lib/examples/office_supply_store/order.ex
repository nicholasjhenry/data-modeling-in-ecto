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

  def put_line_item_changeset(order, line_item_attrs) do
    changeset = change(order)

    line_item_changeset = OrderLineItem.changeset(%OrderLineItem{}, line_item_attrs)
    line_items = [line_item_changeset | changeset.data.line_items]

    changeset
    |> put_assoc(:line_items, line_items)
    |> validate_line_items
  end

  defp validate_line_items(order_changeset) do
    line_item_changesets = get_assoc(order_changeset, :line_items)

    if Enum.count(line_item_changesets) == 0 do
      add_error(order_changeset, :business_rule, "An order requires at least one line item")
    else
      order_changeset
    end
  end
end
