defmodule Examples.PublicLibrary.Patron do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Examples.PublicLibrary.Person
  alias Examples.PublicLibrary.ResourceHold

  schema "public_library_patrons" do
    field :type, Ecto.Enum, values: [:regular, :researcher]
    field :state, Ecto.Enum, values: [:active, :inactive, :expired], default: :active
    field :registration_number, :string
    field :permit_resource_fees, :boolean, default: false

    field :name, :string, virtual: true
    field :born_on, :date, virtual: true

    # NOTE: This is a fun pattern to discuss in the talk
    field :max_resource_hold_count, :integer, virtual: true
    field :resource_hold_count, :integer, virtual: true
    field :age_group, Ecto.Enum, values: [:child, :adult], virtual: true

    belongs_to :person, Person
    has_many :resource_holds, ResourceHold

    timestamps()
  end

  # NOTE: This validation and other is why different schema modules are require for different "types"
  @regular_patron_max_resource_hold_count 5

  @doc false
  def base_query(query \\ __MODULE__) do
    from patron in query,
      join: person in assoc(patron, :person),
      select: %{patron | name: person.name, born_on: person.born_on}
  end

  # SECTION: Field changesets

  @doc false
  def changeset(patron, attrs) do
    patron
    |> cast(attrs, [:type, :registration_number, :permit_resource_fees])
    |> validate_required([:type])
    |> unique_constraint(:registration_number)
  end

  # SECTION: Field calculations

  @doc false
  def calculate_resource_hold_count(patron) do
    resource_hold_count = Enum.count(patron.resource_holds)
    %{patron | resource_hold_count: resource_hold_count}
  end

  @doc false
  def determine_max_resource_hold_count(patron, opts \\ []) do
    max_resource_hold_count =
      Keyword.get(opts, :max_resource_hold_count, @regular_patron_max_resource_hold_count)

    if patron.type == :regular do
      %{patron | max_resource_hold_count: max_resource_hold_count}
    else
      patron
    end
  end

  @years_in_days_18 18 * 365

  @doc false
  def determine_age_group(patron, opts \\ []) do
    current_date_time = Keyword.get(opts, :current_date_time, DateTime.utc_now())
    current_date = DateTime.to_date(current_date_time)

    age_group =
      if @years_in_days_18 < Date.diff(current_date, patron.born_on) do
        :adult
      else
        :child
      end

    %{patron | age_group: age_group}
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
    |> validate_resource_count(patron)
    |> validate_age_group(patron)
    |> validate_registration_number(patron)
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

  defp validate_resource_count(resource_hold_changeset, patron) do
    if patron.type == :regular and patron.max_resource_hold_count < patron.resource_hold_count + 1 do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "A regular patron limited to the number of holds on a resource"
      )
    else
      resource_hold_changeset
    end
  end

  defp validate_age_group(resource_hold_changeset, patron) do
    if patron.age_group != :adult do
      add_error(resource_hold_changeset, :business_rule, "Patron must be an adult")
    else
      resource_hold_changeset
    end
  end

  defp validate_registration_number(resource_hold_changeset, patron) do
    if is_nil(patron.registration_number) do
      add_error(
        resource_hold_changeset,
        :business_rule,
        "A valid registration number is required for a patron"
      )
    else
      resource_hold_changeset
    end
  end
end
