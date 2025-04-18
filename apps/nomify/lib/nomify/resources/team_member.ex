defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset
  import Nomify.Result

  alias Nomify.Resources.Privileges
  alias Nomify.Resources.Person
  alias Nomify.Resources.Team

  schema "resource_team_members" do
    field :team_role, Ecto.Enum, values: [:admin, :chair, :member], default: :member
    field :privileges, Nomify.Resources.Privileges, default: Nomify.Resources.Privileges.none()
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret], default: :low
    # NOTE: actor - role (generic - specific)
    belongs_to :person, Person
    # NOTE: group - member (whole - part)
    belongs_to :team, Team

    timestamps()
  end

  # SECTION: Field changesets

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
  def team_role_changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team_role])
    |> validate_required([:team_role])
    |> validate_team_role
  end

  # SECTION: Field validations

  defp validate_team_role(changeset) do
    team = changeset.data.team
    team_role = get_change(changeset, :team_role)

    team
    |> check_role_chair(team_role)
    |> put_result(changeset, :team_role)
  end

  defp check_role_chair(team, team_role) do
    if team_role == :chair do
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
  def check_nomination(team_member) do
    if Privileges.has_flag(team_member.privileges, :nominate),
      do: :ok,
      else: {:error, "Security violation. Team member cannot nominate."}
  end
end
