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

  @doc false
  def put_person_changeset(patron, person) do
    patron
    |> put_assoc(:person, person)
  end

  # SECTION: Assoc validations

  @doc false
  def validate_put_resource_hold(resource_hold_changeset, patron) do
    resource_hold_changeset
    |> validate_resource_hold_type(patron)
  end

  defp validate_resource_hold_type(resource_hold_changeset, patron) do
    resource_hold_type = get_field(resource_hold_changeset, :type)

    if patron.type == :regular and resource_hold_type == :open_ended do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "A regular patron can only place closed-ended holds on a resource"
      )
    else
      resource_hold_changeset
    end
  end
end
