defmodule Examples.LuxuryCatalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Examples.LuxuryCatalog.Category

  schema "luxury_catalog_products" do
    field :name, :string
    field :brand_code, :string
    field :permitted_category_codes, {:array, :string}
    field :competitor_brand_codes, {:array, :string}, default: []
    field :max_category_count, :integer
    field :max_category_member_count, :integer
    field :state, Ecto.Enum, values: [:active, :discontinued], default: :active
    field :color, Ecto.Enum, values: [:black, :red, :blue, :green]
    field :price, :decimal

    field :category_count, :integer, virtual: true

    many_to_many :categories, Category, join_through: "luxury_catalog_category_products"

    timestamps()
  end

  # SECTION: Field changesets

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :brand_code,
      :permitted_category_codes,
      :competitor_brand_codes,
      :max_category_count,
      :max_category_member_count,
      :color,
      :price
    ])
    |> validate_required([
      :name,
      :brand_code,
      :competitor_brand_codes,
      :max_category_member_count,
      :color,
      :price
    ])
    |> unique_constraint(:name)
  end

  @doc false
  def discontinue_changeset(product) do
    product
    |> change
    |> put_change(:state, :discontinued)
  end

  # SECTION: Calculations

  @doc false
  def calculate_category_count(product) do
    category_count = Enum.count(product.categories)
    %{product | category_count: category_count}
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_category_changeset(category_changeset, product) do
    product = %{product | category_count: product.category_count + 1}

    category_changeset
    |> validate_permitted_categories(product)
    |> validate_max_category_count(product)
    |> validate_max_category_member_count(product)
    |> validate_state(product)
    |> validate_competitor_brand_conflict(product)
  end

  defp validate_permitted_categories(
         category_changeset,
         %{permitted_category_codes: nil} = _product
       ) do
    category_changeset
  end

  defp validate_permitted_categories(
         category_changeset,
         %{permitted_category_codes: permitted_category_codes} = _product
       )
       when is_list(permitted_category_codes) do
    category_code = get_field(category_changeset, :code)

    if category_code not in permitted_category_codes do
      add_error(
        category_changeset,
        :business_rule,
        "Product is not permitted to be added to this category"
      )
    else
      category_changeset
    end
  end

  defp validate_max_category_count(category_changeset, product) do
    if product.max_category_count < product.category_count do
      add_error(
        category_changeset,
        :business_rule,
        "Maximum category count exceeded for this product"
      )
    else
      category_changeset
    end
  end

  defp validate_max_category_member_count(category_changeset, product) do
    product_count = get_field(category_changeset, :product_count)

    if product.max_category_member_count < product_count do
      add_error(
        category_changeset,
        :business_rule,
        "Maximum category member count exceeded for this product"
      )
    else
      category_changeset
    end
  end

  defp validate_state(category_changeset, product) do
    if product.state != :active do
      add_error(category_changeset, :business_rule, "Product is not active")
    else
      category_changeset
    end
  end

  defp validate_competitor_brand_conflict(category_changeset, product) do
    category_products = get_assoc(category_changeset, :products, :struct)

    if brands_compatible?(product, category_products) do
      add_error(category_changeset, :business_rule, "Product has a conflict")
    else
      category_changeset
    end
  end

  defp brands_compatible?(product, category_products) do
    category_product_brand_codes_set =
      category_products
      |> Enum.map(& &1.brand_code)
      |> MapSet.new()

    product_competitor_brand_codes_set = MapSet.new(product.competitor_brand_codes)

    conflicted_brand_code_set =
      MapSet.intersection(product_competitor_brand_codes_set, category_product_brand_codes_set)

    MapSet.size(conflicted_brand_code_set) > 0
  end
end
