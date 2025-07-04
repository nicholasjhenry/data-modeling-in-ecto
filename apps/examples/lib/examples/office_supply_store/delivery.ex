defmodule Examples.OfficeSupplyStore.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_deliveries" do
    field :type, Ecto.Enum, values: [:partial, :complete]
    field :state, Ecto.Enum, values: [:pending, :completed, :cancelled]
    field :address, :string
    field :order_id, :id

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:type, :state, :address])
    |> validate_required([:type, :state, :address])
  end
end
