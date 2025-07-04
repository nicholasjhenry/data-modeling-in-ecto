defmodule Examples.OfficeSupplyStore.StockEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_stock_entries" do
    belongs_to :branch, Examples.OfficeSupplyStore.Branch
    belongs_to :product, Examples.OfficeSupplyStore.Product

    timestamps()
  end

  @doc false
  def put_branch_changeset(stock_entry, branch) do
    stock_entry
    |> change
    |> put_assoc(:branch, branch)
  end

  def put_product_changeset(stock_entry, product) do
    stock_entry
    |> change
    |> put_assoc(:product, product)
  end
end
