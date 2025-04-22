defmodule Nomify.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  # SECTION: Team

  alias Nomify.Resources.Team
  alias Nomify.Resources.TeamMember

  def list_teams do
    Repo.all(Team)
  end

  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(team_members: TeamMember.base_query())
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def team_equal?(lhs, rhs) do
    lhs.id == rhs.id &&
      lhs.description == rhs.description &&
      lhs.format == rhs.format
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
  def create_team_member(team, person) do
    %TeamMember{}
    # NOTE: Streamlined Object Modeling
    #
    # Principle 75: Properties Before Collaborators
    #
    # Object construction methods initialize properties before establishing collaborations because
    # collaboration rules may check property values.
    #
    |> TeamMember.insert_changeset()
    |> TeamMember.put_team(team)
    |> TeamMember.put_person(person)
    |> Repo.insert()
  end

  def update_team_member(%TeamMember{} = team_member, attrs) do
    team_member
    |> TeamMember.changeset(attrs)
    |> Repo.update()
  end

  def update_team_member_role(team_member, attrs) do
    team_member
    |> Repo.preload(team: :team_members)
    |> TeamMember.role_changeset(attrs)
    |> Repo.update()
  end

  def update_team_member_privileges(team_member, attrs) do
    team_member
    |> TeamMember.privileges_changeset(attrs)
    |> Repo.update()
  end

  def delete_team_member(%TeamMember{} = team_member) do
    Repo.delete(team_member)
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
