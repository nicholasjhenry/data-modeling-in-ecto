defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset
  import Nomify.Result

  alias Nomify.Documents.Nomination
  alias Nomify.Resources.Privileges
  alias Nomify.Resources.Person
  alias Nomify.Resources.Team

  schema "resource_team_members" do
    field :role, Ecto.Enum, values: [:admin, :chair, :member], default: :member
    field :privileges, Nomify.Resources.Privileges, default: Nomify.Resources.Privileges.none()
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret], default: :low
    # NOTE: actor - role (generic - specific)
    belongs_to :person, Person
    # NOTE: group - member (whole - part)
    belongs_to :team, Team

    has_many :nominations, Nomination

    timestamps()
  end

  # Number of documents can nominate per nomination time period.
  @max_chair_documents 5
  @default_max_documents 10

  # Number of days in nomination time period.
  @nominations_time_period {30, :day}

  # SECTION: State Queries

  @doc false
  def max_nominations_allowed(team_member, opts) do
    max_documents = Keyword.get(opts, :max_documents, false)

    cond do
      max_documents -> max_documents
      team_member.role -> @max_chair_documents
      true -> @default_max_documents
    end
  end

  @doc false
  def count_nominations_per_period(team_member, opts \\ []) do
    end_date = Keyword.get(opts, :end_date, Date.utc_today())
    {days, :day} = @nominations_time_period

    start_date = Date.add(end_date, -days)
    date_range = Date.range(start_date, end_date)

    Enum.count(team_member.nominations, &Enum.member?(date_range, &1.nomination_date))
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
    privileges = Nomify.Resources.Privileges.parse(attrs)

    team_member
    |> change
    |> put_change(:privileges, privileges)
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
    team = changeset.data.team
    role = get_change(changeset, :role)

    team
    |> check_role_chair(role)
    |> put_result(changeset, :role)
  end

  defp check_role_chair(team, role) do
    if role == :chair do
      Team.check_chair_eligibility(team)
    else
      :ok
    end
  end

  # SECTION: Assoc Changesets

  @doc false
  def put_team(changeset, team) do
    changeset
    |> put_assoc(:team, team)
    |> validate_team()
  end

  @doc false
  def put_person(changeset, person) do
    changeset
    |> put_assoc(:person, person)
    |> validate_person()
  end

  # SECTION: Assoc Validations

  defp validate_team(changeset) do
    unique_constraint(changeset, [:person_id, :team_id],
      message: "Tried to add person twice to team.",
      error_key: :business_rule,
      name: :resource_team_members_team_id_person_id_index
    )
  end

  defp validate_person(changeset) do
    person = get_assoc(changeset, :person, :struct)

    if Person.valid_email?(person) do
      changeset
    else
      add_error(changeset, :business_rule, "Person cannot be team member. Invalid email.")
    end
  end

  @doc false
  def check_nomination(team_member, opts \\ []) do
    nomination_allowance_opts = Keyword.get(opts, :nomination_allowance, [])

    cond do
      !Privileges.has_flag(team_member.privileges, :nominate) ->
        {:error, "Security violation. Team member cannot nominate."}

      count_nominations_per_period(team_member) >=
          max_nominations_allowed(team_member, nomination_allowance_opts) ->
        {:error, "Team member cannot nominate. Too many nominations."}

      true ->
        :ok
    end
  end
end
