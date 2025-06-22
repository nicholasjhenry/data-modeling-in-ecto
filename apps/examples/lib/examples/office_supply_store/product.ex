defmodule Examples.OfficeSupplyStore.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_products" do
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
