defmodule Examples.OfficeSupplyStore.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import EssentialEcto

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

  def put_line_item_changeset(order, product, line_item_attrs) do
    changeset = change(order)

    line_item_changeset =
      %OrderLineItem{}
      |> OrderLineItem.changeset(line_item_attrs)
      |> OrderLineItem.put_product_changeset(product)

    changeset
    |> put_assoc(:line_items, [line_item_changeset | changeset.data.line_items])
    |> validate_line_items
  end

  def put_line_item_changeset(order, line_item_attrs) do
    changeset = change(order)

    line_item_changeset = OrderLineItem.changeset(%OrderLineItem{}, line_item_attrs)

    changeset
    |> put_assoc(:line_items, [line_item_changeset | changeset.data.line_items])
    |> validate_line_items
  end

  def delete_line_item_changeset(order, line_item) do
    order
    |> change
    |> delete_assoc(:line_items, line_item)
    |> validate_line_items
  end

  defp validate_line_items(order_changeset) do
    line_item_changesets = get_all_assocs(order_changeset, :line_items, :insert_or_update)

    if Enum.count(line_item_changesets) == 0 do
      add_error(order_changeset, :business_rule, "An order requires at least one line item")
    else
      order_changeset
    end
  end
end
