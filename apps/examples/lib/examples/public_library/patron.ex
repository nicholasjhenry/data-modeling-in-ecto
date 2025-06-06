defmodule Examples.PublicLibrary.Patron do
  use Ecto.Schema
  import Ecto.Changeset

  schema "public_library_patrons" do
    field :type, Ecto.Enum, values: [:regular, :researcher]
    field :state, Ecto.Enum, values: [:active, :inactive, :expired]
    field :registration_number, :string
    field :person_id, :id

    timestamps()
  end

  @doc false
  def changeset(patron, attrs) do
    patron
    |> cast(attrs, [:type, :state, :registration_number])
    |> validate_required([:type, :state, :registration_number])
    |> unique_constraint(:registration_number)
  end
end
