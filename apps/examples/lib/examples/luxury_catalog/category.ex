defmodule Examples.LuxuryCatalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.LuxuryCatalog.Product
  alias PgRanges.NumRange

  schema "luxury_catalog_categories" do
    field :name, :string
    field :code, :string
    field :max_product_count, :integer
    field :permitted_colours, {:array, :string}, default: []

    field :permitted_price_range, NumRange,
      default: NumRange.new(Decimal.new(0), Decimal.new(100))

    field :state, Ecto.Enum, values: [:active, :discountinued, :expired], default: :active
    field :mutually_exclusive, :boolean, default: false

    many_to_many :products, Product, join_through: "luxury_catalog_category_products"

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [
      :name,
      :code,
      :max_product_count,
      :permitted_colours,
      :permitted_price_range,
      :mutually_exclusive
    ])
    |> validate_required([
      :name
    ])
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end

  @doc false
  def add_product_changeset(category, product) do
    category
    |> change
    |> put_assoc(:products, [product | category.products])
  end
end
