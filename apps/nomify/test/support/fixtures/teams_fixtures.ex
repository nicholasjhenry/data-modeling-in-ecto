defmodule Nomify.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Teams` context.
  """

  import Nomify.DirectoryFixtures

  @doc """
  Generate a team.
  """
  def team_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        format: :none
      })

    {:ok, team} = Nomify.Teams.create_team(scope, attrs)

    team
  end

  @doc """
  Generate a team_member.
  """
  # NOTE: Pass associated structs or create them?
  def team_member_fixture(scope, assocs \\ %{}) do
    assocs = Map.new(assocs)
    team = Map.get_lazy(assocs, :team, fn -> team_fixture(scope) end)
    person = Map.get_lazy(assocs, :person, fn -> person_fixture(scope) end)

    {:ok, team_member} = Nomify.Teams.create_team_member(scope, team, person)

    team_member
  end

  def update_team_member_privilege(scope, team_member, privilege) do
    {:ok, team_member} =
      Nomify.Teams.update_team_member_privileges(scope, team_member, %{privilege => true})

    team_member
  end

  def update_team_member_security_level(scope, team_member, security_level) do
    {:ok, team_member} =
      Nomify.Teams.update_team_member(scope, team_member, %{security_level: security_level})

    team_member
  end
end
