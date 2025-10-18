defmodule Nomify.Teams do
  @moduledoc """
  The Teams component is responsible for managing teams and members.
  """

  use Nomify, :context

  alias Nomify.Directory
  alias Nomify.Accounts.Scope

  # SECTION: Team

  alias Nomify.Teams.Team
  alias Nomify.Teams.TeamMember

  @spec subscribe_teams(Scope.t()) :: :ok | {:error, term()}
  def subscribe_teams(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:teams")
  end

  @spec broadcast_teams(Scope.t(), term()) :: :ok | {:error, term()}
  defp broadcast_teams(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:teams", message)
  end

  @spec list_teams :: list(Team.t())
  def list_teams do
    Repo.all(Team)
  end

  @spec get_team!(Identifier.t()) :: Team.t()
  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(team_members: TeamMember.base_query())
  end

  @spec create_team(Scope.t()) ::
          {:ok, Team.t()} | {:error, Changeset.t(Team.t())}
  @spec create_team(Scope.t(), Attrs.t()) ::
          {:ok, Team.t()} | {:error, Changeset.t(Team.t())}
  def create_team(scope, attrs \\ %{}) do
    with {:ok, team = %Team{}} <-
           %Team{}
           |> Team.changeset(attrs)
           |> Repo.insert() do
      broadcast_teams(scope, {:created, team})
      {:ok, team}
    end
  end

  @spec update_team(Scope.t(), Team.t(), Attrs.t()) ::
          {:ok, Team.t()} | {:error, Changeset.t(Team.t())}
  def update_team(%Scope{} = scope, %Team{} = team, attrs) do
    with {:ok, team = %Team{}} <-
           team
           |> Team.changeset(attrs)
           |> Repo.update() do
      broadcast_teams(scope, {:updated, team})
      {:ok, team}
    end
  end

  @spec delete_team(Scope.t(), Team.t()) ::
          {:ok, Team.t()} | {:error, Changeset.t(Team.t())}
  def delete_team(%Scope{} = scope, %Team{} = team) do
    with {:ok, team = %Team{}} <-
           Repo.delete(team) do
      broadcast_teams(scope, {:deleted, team})
      {:ok, team}
    end
  end

  @spec change_team(Team.t()) :: Changeset.t(Team.t())
  @spec change_team(Team.t(), Attrs.t()) :: Changeset.t(Team.t())
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  @spec team_equal?(Team.t(), Team.t()) :: boolean()
  def team_equal?(lhs, rhs) do
    lhs.id == rhs.id &&
      lhs.description == rhs.description &&
      lhs.format == rhs.format
  end

  @spec test_team(Scope.t()) :: Team.t()
  def test_team(scope) do
    attrs = %{description: "Test Team", format: :none}
    {:ok, team} = create_team(scope, attrs)
    team
  end

  # SECTION: Team Members
  #
  @spec subscribe_team_members(Scope.t()) :: :ok | {:error, term()}
  def subscribe_team_members(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:team_members")
  end

  @spec broadcast_team_members(Scope.t(), term()) :: :ok | {:error, term()}
  defp broadcast_team_members(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:team_members", message)
  end

  @spec list_team_members :: list(TeamMember.t())
  def list_team_members do
    Repo.all(TeamMember)
  end

  @spec search_team_members_by_name(String.t()) :: list(TeamMember.t())
  def search_team_members_by_name(name) do
    query =
      from team_member in TeamMember,
        join: person in assoc(team_member, :person),
        where: ilike(person.name, ^"%#{name}%")

    query
    |> TeamMember.base_query()
    |> Repo.all()
    |> Repo.preload([:team, :person])
  end

  # NOTE: group-member always scoped by group
  @spec get_team_member!(Team.t(), Identifier.t()) :: TeamMember.t()
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
  @spec create_team_member(Scope.t(), Team.t(), Directory.Person.t()) ::
          {:ok, TeamMember.t()} | {:error, Changeset.t(TeamMember.t())}
  def create_team_member(%Scope{} = scope, team, person) do
    with {:ok, team = %TeamMember{}} <-
           %TeamMember{}
           # NOTE: Principle 75: Properties Before Collaborators
           #
           # > Object construction methods initialize properties before establishing collaborations because
           # > collaboration rules may check property values.
           # >
           # > -- Streamlined Object Modeling
           #
           |> TeamMember.insert_changeset()
           |> TeamMember.put_team_changeset(team)
           |> TeamMember.put_person_changeset(person)
           |> Repo.insert() do
      broadcast_team_members(scope, {:created, team})
      {:ok, team}
    end
  end

  @spec update_team_member(Scope.t(), TeamMember.t(), Attrs.t()) ::
          {:ok, TeamMember.t()} | {:error, Changeset.t(TeamMember.t())}
  def update_team_member(%Scope{} = scope, %TeamMember{} = team_member, attrs) do
    with {:ok, team_member = %TeamMember{}} <-
           team_member
           |> TeamMember.changeset(attrs)
           |> Repo.update() do
      broadcast_team_members(scope, {:updated, team_member})
      {:ok, team_member}
    end
  end

  @spec update_team_member_role(Scope.t(), TeamMember.t(), Attrs.t()) ::
          {:ok, TeamMember.t()} | {:error, Changeset.t(TeamMember.t())}
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

  @spec update_team_member_privileges(Scope.t(), TeamMember.t(), Attrs.t()) ::
          {:ok, TeamMember.t()} | {:error, Changeset.t(TeamMember.t())}
  def update_team_member_privileges(%Scope{} = scope, team_member, attrs) do
    with {:ok, team_member = %TeamMember{}} <-
           team_member
           |> TeamMember.privileges_changeset(attrs)
           |> Repo.update() do
      broadcast_team_members(scope, {:updated, team_member})
      {:ok, team_member}
    end
  end

  @spec delete_team_member(Scope.t(), TeamMember.t()) ::
          {:ok, TeamMember.t()} | {:error, Changeset.t(TeamMember.t())}
  def delete_team_member(%Scope{} = scope, %TeamMember{} = team_member) do
    with {:ok, team_member = %TeamMember{}} <-
           Repo.delete(team_member) do
      broadcast_team_members(scope, {:deleted, team_member})
      {:ok, team_member}
    end
  end

  @spec change_team_member(TeamMember.t()) :: Changeset.t(TeamMember.t())
  @spec change_team_member(TeamMember.t(), Attrs.t()) :: Changeset.t(TeamMember.t())
  def change_team_member(%TeamMember{} = team_member, attrs \\ %{}) do
    TeamMember.changeset(team_member, attrs)
  end

  @spec count_team_member_nominations_per_period(TeamMember.t()) :: integer()
  @spec count_team_member_nominations_per_period(TeamMember.t(), keyword()) :: integer()
  def count_team_member_nominations_per_period(%TeamMember{} = team_member, opts \\ []) do
    team_member
    |> Repo.preload(:nominations)
    |> TeamMember.put_nominations_per_period_count(opts)
    |> Map.fetch!(:nominations_per_period_count)
  end

  @spec team_member_equal?(TeamMember.t(), TeamMember.t()) :: boolean()
  def team_member_equal?(lhs, rhs) do
    lhs.id == rhs.id &&
      lhs.role == rhs.role &&
      lhs.privileges == rhs.privileges &&
      lhs.security_level == rhs.security_level &&
      lhs.person_id == rhs.person_id &&
      lhs.team_id == rhs.team_id
  end

  @spec test_team_member_admin(Scope.t()) :: TeamMember.t()
  def test_team_member_admin(scope) do
    person = Directory.test_person(scope)
    team = test_team(scope)

    {:ok, team_member} = create_team_member(scope, team, person)

    {:ok, team_member} =
      update_team_member_privileges(scope, team_member, %{nominate: true})

    {:ok, team_member_admin} =
      update_team_member_role(scope, team_member, %{role: :admin})

    team_member_admin
  end

  @spec test_team_member_no_nominate(Scope.t()) :: TeamMember.t()
  def test_team_member_no_nominate(scope) do
    person = Directory.test_person(scope)
    team = test_team(scope)

    {:ok, team_member_no_nominate} = create_team_member(scope, team, person)
    team_member_no_nominate
  end

  @spec test_team_member_secret(Scope.t()) :: TeamMember.t()
  def test_team_member_secret(scope) do
    person = Directory.test_person(scope)
    team = test_team(scope)

    {:ok, team_member} = create_team_member(scope, team, person)

    {:ok, team_member} =
      update_team_member_privileges(scope, team_member, %{nominate: true})

    {:ok, team_member_secret} = update_team_member(scope, team_member, %{security_level: :secret})
    team_member_secret
  end
end
