defmodule Examples.OfficeSupplyStore.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_supply_store_people" do
    field :name, :string
    field :born_at, :date
    field :email, :string
    field :telephone_number, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :born_at, :email, :telephone_number])
    |> validate_required([:name, :born_at, :email, :telephone_number])
  end
end
