defmodule Examples.LuxuryCatalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.LuxuryCatalog.Product
  alias PgRanges.NumRange

  schema "luxury_catalog_categories" do
    field :name, :string
    field :code, :string
    field :max_product_count, :integer
    field :permitted_product_colors, {:array, :string}

    field :permitted_product_price_range, NumRange

    field :state, Ecto.Enum, values: [:active, :discountinued, :expired], default: :active
    field :mutually_exclusive, :boolean, default: false

    field :product_count, :integer, virtual: true

    many_to_many :products, Product, join_through: "luxury_catalog_category_products"

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [
      :name,
      :code,
      :max_product_count,
      :permitted_product_colors,
      :permitted_product_price_range,
      :mutually_exclusive
    ])
    |> validate_required([
      :name,
      :code
    ])
    |> unique_constraint(:name)
    |> unique_constraint(:code)
  end

  @doc false
  def discontinue_changeset(category) do
    category
    |> change
    |> put_change(:state, :discountinued)
  end

  # SECTION: Calculations

  @doc false
  def calculate_product_count(category) do
    product_count = Enum.count(category.products)
    %{category | product_count: product_count}
  end

  # SECTION: Assoc changesets

  @doc false
  def put_product_changeset(category, product) do
    changeset = change(category)

    product_count = get_field(changeset, :product_count) + 1

    changeset
    |> put_assoc(:products, [product | category.products])
    |> put_change(:product_count, product_count)
    |> validate_put_product_changeset(product)
    |> Product.validate_put_category_changeset(product)
  end

  def validate_put_product_changeset(changeset, product) do
    changeset
    |> validate_product_count()
    |> validate_permitted_product_colors(product)
    |> validate_permitted_product_price(product)
    |> validate_state()
  end

  # SECTION: Assoc validations

  defp validate_product_count(changeset) do
    product_count = get_field(changeset, :product_count)
    max_product_count = get_field(changeset, :max_product_count)

    if max_product_count < product_count do
      add_error(changeset, :business_rule, "Maximum product count exceeded for this category")
    else
      changeset
    end
  end

  defp validate_permitted_product_colors(changeset, product) do
    permitted_product_colors = get_field(changeset, :permitted_product_colors)

    if is_list(permitted_product_colors) and
         not Enum.member?(permitted_product_colors, to_string(product.color)) do
      add_error(changeset, :business_rule, "Product color not permitted for this category")
    else
      changeset
    end
  end

  defp validate_permitted_product_price(changeset, product) do
    permitted_product_price_range = get_field(changeset, :permitted_product_price_range)

    if not is_nil(permitted_product_price_range) and
         not price_in_range?(permitted_product_price_range, product.price) do
      add_error(changeset, :business_rule, "Product price not permitted for this category")
    else
      changeset
    end
  end

  defp price_in_range?(permitted_product_price_range, product_price) do
    Decimal.compare(product_price, permitted_product_price_range.lower) == :gt and
      Decimal.compare(product_price, permitted_product_price_range.upper) == :lt
  end

  defp validate_state(changeset) do
    state = get_field(changeset, :state)

    if state != :active do
      add_error(changeset, :business_rule, "Category is not active")
    else
      changeset
    end
  end
end
