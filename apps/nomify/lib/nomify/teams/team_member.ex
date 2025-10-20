defmodule Nomify.Teams.TeamMember do
  @moduledoc """
  A member of a team who holds a specific role and privileges. A person can
  play different roles -- chair, admin, or member -- on many different teams.

  > #### Essential Ecto {: .info}
  >
  > The team member implements all three templates:
  > - Generic - **Specific** (Actor - Role)
  > - Whole - **Part** (Group - Member)
  > - **Specific** - Transaction (Role - Transaction)
  >
  > See **Associations** below.
  """

  use Nomify, :record

  alias Nomify.SecurityLevel

  alias Nomify.Directory.Person
  alias Nomify.Documents.Nomination
  alias Nomify.Teams.Privileges
  alias Nomify.Teams.Team

  @typedoc """
  ## Fields
  A TeamMember has these fields:

  - `role` (role): The role of the team member (e.g., admin, chair, member).
  - `privileges` (descriptive): The privileges assigned to the team member.
  - `security_level` (type): The security classification of the team member.
  - `nominations_per_period_count` (descriptive): The count of nominations made by the team member in the current period.
  - `max_nominations_allowed` (descriptive): The maximum number of nominations allowed for the team member in the current period.


  > #### Essential Ecto {: .info}
  >
  > Record Inheritance
  >
  > Any coding template for the generic – specific pattern must accommodate the object inheritance
  > mechanism, which specifies the properties and services in the generic that are accessible from
  > the specific object. What object inheritance really means is that certain determine mine and
  > analyze transactions services available in the generic are also available in the specific.
  >
  > -- Streamlined Object Modeling

  - `title` (descriptive): The title or honorific of the team member.
  - `name` (descriptive): The full name of the team member.
  - `email` (descriptive): The email address of the team member.

  ## Associations

  A TeamMember associates with:

  - `person` (Actor - Role): Links the team member to a person entity, representing the individual associated with the team member.
  - `team` (Group - Member): Represents the team to which the team member belongs.
  - `nominations` (Role - Transaction): The nominations made by the team member.
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          role: :admin | :chair | :member,
          privileges: Privileges.t(),
          security_level: SecurityLevel.t(),
          nominations_per_period_count: integer() | nil,
          max_nominations_allowed: integer() | nil,
          title: String.t() | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          person_id: integer() | nil,
          person: Person.t() | Ecto.Association.NotLoaded.t() | nil,
          team_id: integer() | nil,
          team: Team.t() | Ecto.Association.NotLoaded.t() | nil,
          nominations: list(Nomination.t()) | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "team_members" do
    # SECTION: Fields
    # SOM: Principle 73
    field :role, Ecto.Enum, values: [:admin, :chair, :member], default: :member
    field :privileges, Privileges, default: Privileges.none()
    field :security_level, Ecto.Enum, values: SecurityLevel.values(), default: :low

    # SECTION: Fields - Calculated
    field :nominations_per_period_count, :integer, virtual: true
    field :max_nominations_allowed, :integer, virtual: true

    # SECTION: Fields - Person
    field :title, :string, virtual: true
    field :name, :string, virtual: true
    field :email, :string, virtual: true

    # SECTION: Associations
    belongs_to :person, Person
    belongs_to :team, Team
    has_many :nominations, Nomination

    timestamps()
  end

  # Number of documents can nominate per nomination time period.
  @max_chair_documents 5
  @default_max_documents 10

  # Number of days in nomination time period.
  @nominations_time_period {30, :day}

  # SECTION: Database Queries

  @doc false
  def base_query(query \\ __MODULE__) do
    from team_member in query,
      join: person in assoc(team_member, :person),
      join: team in assoc(team_member, :team),
      select: %{team_member | title: person.title, name: person.name, email: person.email},
      preload: [team: team]
  end

  # SECTION: State Queries

  @doc false
  def determine_max_nominations_allowed(team_member, opts) do
    max_documents = Keyword.get(opts, :max_documents, false)

    amount =
      cond do
        max_documents -> max_documents
        team_member.role -> @max_chair_documents
        true -> @default_max_documents
      end

    %{team_member | max_nominations_allowed: amount}
  end

  @doc false
  def put_nominations_per_period_count(team_member, opts \\ []) do
    end_date = Keyword.get(opts, :end_date, Date.utc_today())
    {days, :day} = @nominations_time_period

    start_date = Date.add(end_date, -days)
    date_range = Date.range(start_date, end_date)

    count = Enum.count(team_member.nominations, &Enum.member?(date_range, &1.nomination_date))

    %{team_member | nominations_per_period_count: count}
  end

  # SECTION: Field Changesets

  @doc false
  def insert_changeset(team_member) do
    change(team_member)
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:security_level])
    |> validate_required([:security_level])
  end

  @doc false
  def privileges_changeset(team_member, attrs) do
    privileges = Privileges.parse(attrs)
    change(team_member, %{privileges: privileges})
  end

  @doc false
  def role_changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> validate_role
  end

  # SECTION: Field validations

  defp validate_role(changeset) do
    team = get_assoc(changeset, :team, :struct)
    role = get_change(changeset, :role)

    if role == :chair do
      Team.validate_chair_eligibility(team, changeset)
    else
      changeset
    end
  end

  # SECTION: Assoc Changesets

  @doc false
  def put_person_changeset(changeset, person) do
    changeset
    |> put_assoc(:person, person)
    |> validate_person()
  end

  @doc false
  def put_team_changeset(changeset, team) do
    changeset
    |> put_assoc(:team, team)
    |> validate_team()
  end

  # SECTION: Assoc Validations

  defp validate_person(changeset) do
    changeset
    # VALIDATION: Type (enforced by Ecto)
    # VALIDATION: Cardinality
    # VALIDATION: Fields
    |> validate_email
    # VALIDATION: State
    # VALIDATION: Conflict
    |> validate_person_team_conflict()
  end

  defp validate_team(changeset) do
    team = get_assoc(changeset, :team, :struct)

    team
    |> Team.validate_team_member(changeset)
    # VALIDATION: Type (enforced by Ecto)
    # VALIDATION: Cardinality
    # VALIDATION: Fields
    # VALIDATION: State
    # VALIDATION: Conflict
    |> validate_person_team_conflict()
  end

  @doc false
  def validate_nomination(team_member, nomination_changeset, opts \\ []) do
    nomination_changeset
    # VALIDATION: Type (enforced by Ecto)
    # VALIDATION: Cardinality
    # VALIDATION: Fields
    # VALIDATION: State
    # VALIDATION: Conflict
    |> validate_nomination_conflict(team_member, opts)
  end

  defp validate_email(changeset) do
    person = get_assoc(changeset, :person, :struct)

    if Person.valid_email?(person) do
      changeset
    else
      add_error(changeset, :business_rule, "Person cannot be team member. Invalid email.")
    end
  end

  # SOM: Conflict Rules
  #
  # > Conflict rules come into play when business rules define restrictions between objects that
  # > collaborate through an intermediary object. In essence, conflict rules are collaboration
  # > rules between indirect collaborators, that is, in-laws.
  # >
  # > -- Streamlined Object Modeling

  defp validate_person_team_conflict(changeset) do
    unique_constraint(changeset, [:person_id, :team_id],
      message: "Tried to add person twice to team.",
      error_key: :business_rule,
      name: :team_members_team_id_person_id_index
    )
  end

  defp validate_nomination_conflict(changeset, team_member, opts) do
    nomination_allowance_opts = Keyword.get(opts, :nomination_allowance, [])

    team_member =
      team_member
      |> put_nominations_per_period_count()
      |> determine_max_nominations_allowed(nomination_allowance_opts)

    cond do
      !Privileges.has_flag(team_member.privileges, :nominate) ->
        add_error(
          changeset,
          :business_rule,
          "Security violation. Team member cannot nominate."
        )

      team_member.nominations_per_period_count >= team_member.max_nominations_allowed ->
        add_error(
          changeset,
          :business_rule,
          "Team member cannot nominate. Too many nominations."
        )

      true ->
        changeset
    end
  end

  defimpl String.Chars do
    def to_string(team_member) do
      "#{team_member.name} (#{team_member.title}) of #{team_member.team.description}"
    end
  end
end
