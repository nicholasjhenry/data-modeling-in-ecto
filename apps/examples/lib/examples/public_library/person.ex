defmodule Examples.PublicLibrary.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_people" do
    field :name, :string
    field :born_on, :date

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :born_on])
    |> validate_required([:name, :born_on])
  end
end
