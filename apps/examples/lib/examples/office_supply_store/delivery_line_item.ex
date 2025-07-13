defmodule Examples.OfficeSupplyStore.DeliveryLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.OfficeSupplyStore.OrderLineItem

  schema "office_supply_store_delivery_line_items" do
    field :quantity, :integer
    field :delivery_id, :id

    belongs_to :order_line_item, OrderLineItem

    timestamps()
  end

  @doc false
  def changeset(delivery_line_item, attrs) do
    delivery_line_item
    |> cast(attrs, [:order_line_item_id, :quantity])
    |> validate_required([:order_line_item_id, :quantity])
  end

  @doc false
  def validate_put_order_line_item_changeset(changeset, order_line_items) do
    case apply_action(changeset, :validate) do
      {:ok, delivery_line_item} ->
        order_line_item =
          order_line_items
          |> Enum.find(&(&1.id == delivery_line_item.order_line_item_id))
          |> OrderLineItem.put_quantity_delivered(delivery_line_item)

        if OrderLineItem.quantity_exceeded?(order_line_item) do
          add_error(changeset, :quantity, "exceeds quantity ordered")
        else
          changeset
        end

      {:error, _changeset} ->
        changeset
    end
  end
end
