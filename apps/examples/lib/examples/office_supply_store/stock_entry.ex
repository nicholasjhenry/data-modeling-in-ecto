defmodule Examples.OfficeSupplyStore.StockEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_stock_entries" do

    field :branch_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(stock_entry, attrs) do
    stock_entry
    |> cast(attrs, [])
    |> validate_required([])
  end
end
