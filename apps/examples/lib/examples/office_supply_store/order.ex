defmodule Examples.OfficeSupplyStore.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import EssentialEcto

  alias Examples.OfficeSupplyStore.Branch
  alias Examples.OfficeSupplyStore.OrderLineItem
  alias Examples.OfficeSupplyStore.Product

  schema "office_supply_store_orders" do
    field :state, Ecto.Enum,
      values: [:payment_pending, :delivery_pending, :completed],
      default: :payment_pending

    field :type, Ecto.Enum, values: [:delivery, :pickup], default: :delivery

    has_many :line_items, OrderLineItem
    belongs_to :branch, Branch

    timestamps()
  end

  # SECTION: field changesets

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state, :type])
    |> validate_required([:state, :type])
  end

  # SECTION: assoc changesets

  def put_line_item_changeset(order, product, line_item_attrs) do
    changeset = change(order)

    line_item_changeset =
      %OrderLineItem{}
      |> OrderLineItem.changeset(line_item_attrs)
      |> OrderLineItem.put_product_changeset(product)

    changeset
    |> put_assoc(:line_items, [line_item_changeset | changeset.data.line_items])
    |> validate_line_items
    |> validate_conflict(product)
    |> Product.validate_put_order(product)
  end

  def delete_line_item_changeset(order, line_item) do
    order
    |> change
    |> delete_assoc(:line_items, line_item)
    |> validate_line_items
  end

  def put_branch_changeset(order, branch) do
    order
    |> change
    |> put_assoc(:branch, branch)
  end

  # SECTION: assoc validations

  defp validate_line_items(order_changeset) do
    line_item_changesets = get_all_assocs(order_changeset, :line_items, :insert_or_update)

    if Enum.count(line_item_changesets) == 0 do
      add_error(order_changeset, :business_rule, "An order requires at least one line item")
    else
      order_changeset
    end
  end

  defp validate_conflict(order_changeset, product) do
    branch = get_assoc(order_changeset, :branch, :struct)

    if Enum.any?(branch.stock_entries, &(&1.product_id == product.id)) do
      order_changeset
    else
      add_error(order_changeset, :business_rule, "Product is not stocked by branch")
    end
  end
end
