defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Resources.Person
  alias Nomify.Resources.Team

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
end
