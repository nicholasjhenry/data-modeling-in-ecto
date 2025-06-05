defmodule Examples.LuxuryCatalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "luxury_catalog_products" do
    field :name, :string
    field :permitted_category_codes, {:array, :string}
    field :max_category_count, :integer
    field :max_category_member_count, :integer
    field :state, Ecto.Enum, values: [:active, :discontinued]
    field :color, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :permitted_category_codes, :max_category_count, :max_category_member_count, :state, :color, :price])
    |> validate_required([:name, :permitted_category_codes, :max_category_count, :max_category_member_count, :state, :color, :price])
    |> unique_constraint(:name)
  end
end
