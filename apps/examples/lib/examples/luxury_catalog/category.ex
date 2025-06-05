defmodule Examples.LuxuryCatalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "luxury_catalog_categories" do
    field :name, :string
    field :max_product_count, :integer
    field :permitted_colours, {:array, :string}
    field :permitted_price_range, :decimal
    field :state, Ecto.Enum, values: [:active, :discountinued, :expired]
    field :mutually_exclusive, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :max_product_count, :permitted_colours, :permitted_price_range, :state, :mutually_exclusive])
    |> validate_required([:name, :max_product_count, :permitted_colours, :permitted_price_range, :state, :mutually_exclusive])
    |> unique_constraint(:name)
  end
end
