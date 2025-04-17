defmodule Nomify.Resources.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Util.EmailAddress

  schema "resource_people" do
    field :title, :string
    field :name, :string
    field :email, :string

    timestamps()
  end

  # SECTION: Field Changesets

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:title, :name, :email])
    |> validate_required([:title, :name])
  end

  def valid_email?(person) do
    match?({:ok, _email}, EmailAddress.parse(person.email))
  end
end
