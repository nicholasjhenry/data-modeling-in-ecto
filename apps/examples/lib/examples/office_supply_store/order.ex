defmodule Examples.OfficeSupplyStore.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import EssentialEcto

  alias Examples.OfficeSupplyStore.Branch
  alias Examples.OfficeSupplyStore.BusinessCustomer
  alias Examples.OfficeSupplyStore.Delivery
  alias Examples.OfficeSupplyStore.OrderLineItem
  alias Examples.OfficeSupplyStore.Product

  schema "office_supply_store_orders" do
    field :state, Ecto.Enum,
      values: [:payment_pending, :delivery_pending, :completed],
      default: :payment_pending

    field :type, Ecto.Enum, values: [:delivery, :pickup], default: :delivery
    field :shipping_address, :string

    has_many :line_items, OrderLineItem
    has_many :deliveries, Delivery
    belongs_to :branch, Branch
    belongs_to :customer, BusinessCustomer

    timestamps()
  end

  # SECTION: field changesets

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state, :type, :shipping_address])
    |> validate_required([:state, :type, :shipping_address])
  end

  # SECTION: assoc changesets

  def put_line_item_changeset(order, product, line_item_attrs) do
    order
    |> change()
    |> cast_line_item_assoc(line_item_attrs, product)
    |> validate_line_items()
    |> validate_conflict(product)
    |> Product.validate_put_order(product)
  end

  defp cast_line_item_assoc(changeset, line_item_attrs, product) do
    line_item_changeset =
      %OrderLineItem{}
      |> OrderLineItem.changeset(line_item_attrs)
      |> OrderLineItem.put_product_changeset(product)

    put_assoc(changeset, :line_items, [line_item_changeset | changeset.data.line_items])
  end

  def delete_line_item_changeset(order, line_item) do
    order
    |> change
    |> delete_assoc(:line_items, line_item)
    |> validate_line_items
  end

  def put_customer_changeset(order, customer) do
    order
    |> change
    |> put_assoc(:customer, customer)
  end

  def put_branch_changeset(order, branch) do
    order
    |> change
    |> put_assoc(:branch, branch)
  end

  # SECTION: assoc validations

  def validate_put_delivery(delivery_changeset, order) do
    delivery_changeset
    |> validate_shipping_address(order)
    |> validate_state(order)
  end

  defp validate_shipping_address(delivery_changeset, order) do
    delivery_address = get_field(delivery_changeset, :address)

    if order.shipping_address !== delivery_address do
      add_error(
        delivery_changeset,
        :business_rule,
        "Delivery address must the the same as order shipping address"
      )
    else
      delivery_changeset
    end
  end

  defp validate_state(delivery_changeset, order) do
    if order.state != :completed do
      add_error(delivery_changeset, :business_rule, "An order must be completed to be delivered")
    else
      delivery_changeset
    end
  end

  defp validate_line_items(order_changeset) do
    line_item_changesets = get_all_assocs(order_changeset, :line_items, :insert_or_update)

    if Enum.count(line_item_changesets) == 0 do
      add_error(order_changeset, :business_rule, "An order requires at least one line item")
    else
      order_changeset
    end
  end

  defp validate_conflict(order_changeset, product) do
    order_changeset
    |> validate_stock_availability(product)
    |> validate_product_permissibility(product)
  end

  defp validate_stock_availability(order_changeset, product) do
    branch = get_assoc(order_changeset, :branch, :struct)

    if Enum.any?(branch.stock_entries, &(&1.product_id == product.id)) do
      order_changeset
    else
      add_error(order_changeset, :business_rule, "Product is not stocked by branch")
    end
  end

  defp validate_product_permissibility(order_changeset, product) do
    customer = get_assoc(order_changeset, :customer, :struct)

    if product.type == :speciality and customer.status != :preferred do
      add_error(order_changeset, :business_rule, "Product is not permitted for customer")
    else
      order_changeset
    end
  end
end
