defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Resources.Person
  alias Nomify.Resources.Team
  alias Nomify.Util.EmailAddress

  schema "resource_team_members" do
    field :team_role, Ecto.Enum, values: [:admin, :chair, :member]
    field :privileges, :integer
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]
    # NOTE: actor - role (generic - specific)
    belongs_to :person, Person
    # NOTE: group - member (whole - part)
    belongs_to :team, Team

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team_role, :privileges, :security_level])
    |> validate_required([:team_role, :privileges, :security_level])
  end

  @doc false
  def put_team(changeset, team) do
    put_assoc(changeset, :team, team)
  end

  @doc false
  def put_person(changeset, person) do
    case EmailAddress.parse(person.email) do
      {:ok, _email} ->
        put_assoc(changeset, :person, person)

      :error ->
        add_error(changeset, :business_rule, "Person cannot be team member. Invalid email.")
    end
  end
end
