defmodule Examples.LuxuryCatalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "luxury_catalog_products" do
    field :name, :string
    field :permitted_category_codes, {:array, :string}
    field :max_category_count, :integer
    field :max_category_member_count, :integer
    field :state, Ecto.Enum, values: [:active, :discontinued], default: :active
    field :color, Ecto.Enum, values: [:black, :blue, :green, :white, :yellow]
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :permitted_category_codes,
      :max_category_count,
      :max_category_member_count,
      :color,
      :price
    ])
    |> validate_required([
      :name,
      :max_category_count,
      :max_category_member_count,
      :color,
      :price
    ])
    |> unique_constraint(:name)
  end

  @doc false
  def validate_put_category_changeset(category_changeset, product) do
    category_changeset
    |> validate_permitted_categories(product)
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
end
