defmodule Examples.PublicLibrary.Patron do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Examples.PublicLibrary.Person

  schema "public_library_patrons" do
    field :type, Ecto.Enum, values: [:regular, :researcher]
    field :state, Ecto.Enum, values: [:active, :inactive, :expired], default: :active
    field :registration_number, :string
    field :permit_resource_fees, :boolean, default: false

    field :name, :string, virtual: true
    field :born_on, :date, virtual: true

    belongs_to :person, Person

    timestamps()
  end

  @doc false
  def base_query(query \\ __MODULE__) do
    from patron in query,
      join: person in assoc(patron, :person),
      select: %{patron | name: person.name, born_on: person.born_on}
  end

  @doc false
  def changeset(patron, attrs) do
    patron
    |> cast(attrs, [:type, :registration_number, :permit_resource_fees])
    |> validate_required([:type, :registration_number])
    |> unique_constraint(:registration_number)
  end

  # SECTION: Assoc changesets

  def put_person_changeset(patron, person) do
    patron
    |> put_assoc(:person, person)
  end
end
