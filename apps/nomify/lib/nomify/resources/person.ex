defmodule Nomify.Resources.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_people" do
    field :title, :string
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:title, :name, :email])
    |> validate_required([:title, :name, :email])
  end
end
