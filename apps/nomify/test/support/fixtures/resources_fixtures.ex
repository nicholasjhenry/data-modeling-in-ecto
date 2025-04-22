defmodule Nomify.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Resources` context.
  """

  import Nomify.DirectoryFixtures

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        description: "some description",
        format: :none
      })
      |> Nomify.Resources.create_team()

    team
  end

  @doc """
  Generate a team_member.
  """
  # NOTE: Pass associated structs or create them?
  def team_member_fixture(team \\ team_fixture(), person \\ person_fixture()) do
    {:ok, team_member} = Nomify.Resources.create_team_member(team, person)

    team_member
  end

  def update_team_member_privilege(team_member, privilege) do
    {:ok, team_member} =
      Nomify.Resources.update_team_member_privileges(team_member, %{privilege => true})

    team_member
  end

  def update_team_member_security_level(team_member, security_level) do
    {:ok, team_member} =
      Nomify.Resources.update_team_member(team_member, %{security_level: security_level})

    team_member
  end
end
