defmodule Nomify.Teams do
  @moduledoc """
  The Teams component is responsible for managing teams and members.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  alias Nomify.Accounts.Scope

  # SECTION: Team

  alias Nomify.Teams.Team
  alias Nomify.Teams.TeamMember

  def subscribe_teams(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:teams")
  end

  defp broadcast_teams(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:teams", message)
  end

  def list_teams do
    Repo.all(Team)
  end

  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(team_members: TeamMember.base_query())
  end

  def create_team(scope, attrs \\ %{}) do
    with {:ok, team = %Team{}} <-
           %Team{}
           |> Team.changeset(attrs)
           |> Repo.insert() do
      broadcast_teams(scope, {:created, team})
      {:ok, team}
    end
  end

  def update_team(%Scope{} = scope, %Team{} = team, attrs) do
    with {:ok, team = %Team{}} <-
           team
           |> Team.changeset(attrs)
           |> Repo.update() do
      broadcast_teams(scope, {:updated, team})
      {:ok, team}
    end
  end

  def delete_team(%Scope{} = scope, %Team{} = team) do
    with {:ok, team = %Team{}} <-
           Repo.delete(team) do
      broadcast_teams(scope, {:deleted, team})
      {:ok, team}
    end
  end

  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def team_equal?(lhs, rhs) do
    lhs.id == rhs.id &&
      lhs.description == rhs.description &&
      lhs.format == rhs.format
  end

  # SECTION: Team Members
  #
  def subscribe_team_members(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:team_members")
  end

  defp broadcast_team_members(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:team_members", message)
  end

  def list_team_members do
    Repo.all(TeamMember)
  end

  def search_team_members_by_name(name) do
    query =
      from team_member in TeamMember,
        join: person in assoc(team_member, :person),
        where: ilike(person.name, ^"%#{name}%")

    query
    |> Repo.all()
    |> Repo.preload([:team, :person])
  end

  # NOTE: group-member always scoped by group
  def get_team_member!(team, id) do
    TeamMember
    |> TeamMember.base_query()
    |> Repo.get_by!(id: id, team_id: team.id)
    |> Repo.preload([:team, :person])
  end

  # NOTE: How to pass in associated structs?
  # attrs has a default so felt natural to place at the end of the function
  # team or person first? Both of these felt equal weight, so since it's a `team_member`
  # placed `team` as the first argument.
  #
  def create_team_member(%Scope{} = scope, team, person) do
    with {:ok, team = %TeamMember{}} <-
           %TeamMember{}
           # NOTE: Streamlined Object Modeling
           #
           # Principle 75: Properties Before Collaborators
           #
           # Object construction methods initialize properties before establishing collaborations because
           # collaboration rules may check property values.
           #
           |> TeamMember.insert_changeset()
           |> TeamMember.put_team_changeset(team)
           |> TeamMember.put_person_changeset(person)
           |> Repo.insert() do
      broadcast_team_members(scope, {:created, team})
      {:ok, team}
    end
  end

  def update_team_member(%Scope{} = scope, %TeamMember{} = team_member, attrs) do
    with {:ok, team_member = %TeamMember{}} <-
           team_member
           |> TeamMember.changeset(attrs)
           |> Repo.update() do
      broadcast_team_members(scope, {:updated, team_member})
      {:ok, team_member}
    end
  end

  def update_team_member_role(%Scope{} = scope, team_member, attrs) do
    with {:ok, team_member = %TeamMember{}} <-
           team_member
           |> Repo.preload(team: :team_members)
           |> TeamMember.role_changeset(attrs)
           |> Repo.update() do
      broadcast_team_members(scope, {:updated, team_member})
      {:ok, team_member}
    end
  end

  def update_team_member_privileges(%Scope{} = scope, team_member, attrs) do
    with {:ok, team_member = %TeamMember{}} <-
           team_member
           |> TeamMember.privileges_changeset(attrs)
           |> Repo.update() do
      broadcast_team_members(scope, {:updated, team_member})
      {:ok, team_member}
    end
  end

  def delete_team_member(%Scope{} = scope, %TeamMember{} = team_member) do
    with {:ok, team_member = %TeamMember{}} <-
           Repo.delete(team_member) do
      broadcast_team_members(scope, {:deleted, team_member})
      {:ok, team_member}
    end
  end

  def change_team_member(%TeamMember{} = team_member, attrs \\ %{}) do
    TeamMember.changeset(team_member, attrs)
  end

  def team_member_equal?(lhs, rhs) do
    lhs.id == rhs.id &&
      lhs.role == rhs.role &&
      lhs.privileges == rhs.privileges &&
      lhs.security_level == rhs.security_level &&
      lhs.person_id == rhs.person_id &&
      lhs.team_id == rhs.team_id
  end
end
