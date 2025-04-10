defmodule Nomify.Resources.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_team_members" do
    field :team_role, Ecto.Enum, values: [:admin, :chair, :member]
    field :privileges, :integer
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]
    field :person_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:team_role, :privileges, :security_level])
    |> validate_required([:team_role, :privileges, :security_level])
  end
end
