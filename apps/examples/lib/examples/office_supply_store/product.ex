defmodule Examples.OfficeSupplyStore.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_products" do
    field :name, :string
    field :price, :decimal
    field :type, Ecto.Enum, values: [:standard, :speciality], default: :standard
    field :permitted_order_type, Ecto.Enum, values: [:delivery, :pickup], default: :delivery

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price, :type, :permitted_order_type])
    |> validate_required([:name, :price, :type, :permitted_order_type])
  end

  def validate_put_order(order_changeset, product) do
    validate_order_type(order_changeset, product)
  end

  def validate_order_type(order_changeset, product) do
    order_type = get_field(order_changeset, :type)

    if order_type != product.permitted_order_type do
      add_error(
        order_changeset,
        :business_rule,
        "Product cannot be added to this order type"
      )
    else
      order_changeset
    end
  end
end
