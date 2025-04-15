defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Resources.Person
  alias Nomify.Resources.Team
  alias Nomify.Util.EmailAddress

  schema "resource_team_members" do
    field :team_role, Ecto.Enum, values: [:admin, :chair, :member], default: :member
    field :privileges, :integer, default: 42
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret], default: :low
    # NOTE: actor - role (generic - specific)
    belongs_to :person, Person
    # NOTE: group - member (whole - part)
    belongs_to :team, Team

    timestamps()
  end

  @doc false
  def insert_changeset(team_member) do
    change(team_member)
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:privileges, :security_level])
    |> validate_required([:privileges, :security_level])
  end

  def team_role_changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team_role])
    |> validate_required([:team_role])
    |> validate_team_role
  end

  defp validate_team_role(changeset) do
    team_role = get_change(changeset, :team_role)
    test_team_role(changeset, team_role)
  end

  defp test_team_role(changeset, :chair) do
    case Team.test_chair_eligibility(changeset.data.team) do
      :ok ->
        changeset

      {:error, message} ->
        add_error(changeset, :team_role, message)
    end
  end

  defp test_team_role(changeset, _value) do
    changeset
  end

  @doc false
  def put_team(changeset, team) do
    changeset
    |> unique_constraint([:person_id, :team_id],
      message: "Tried to add person twice to team.",
      error_key: :business_rule,
      name: :resource_team_members_team_id_person_id_index
    )
    |> put_assoc(:team, team)
  end

  @doc false
  def put_person(changeset, person) do
    changeset
    |> validate_email(person)
    |> put_assoc(:person, person)
  end

  defp validate_email(changeset, person) do
    case EmailAddress.parse(person.email) do
      {:ok, _email} ->
        changeset

      :error ->
        add_error(changeset, :business_rule, "Person cannot be team member. Invalid email.")
    end
  end
end
