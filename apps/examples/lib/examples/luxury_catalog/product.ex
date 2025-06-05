defmodule Examples.LuxuryCatalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "luxury_catalog_products" do
    field :name, :string
    field :permitted_category_codes, {:array, :string}, default: []
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
      :permitted_category_codes,
      :max_category_count,
      :max_category_member_count,
      :color,
      :price
    ])
    |> unique_constraint(:name)
  end

  def validate_put_category_changeset(category_changeset, _product) do
    category_changeset
  end
end
