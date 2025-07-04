defmodule Examples.OfficeSupplyStore.Branch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_branches" do
    field :name, :string

    has_many :stock_entries, Examples.OfficeSupplyStore.StockEntry

    timestamps()
  end

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
