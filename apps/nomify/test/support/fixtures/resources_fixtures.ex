defmodule Nomify.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Resources` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        email: "foo@example.com",
        name: "some name",
        title: "some title"
      })
      |> Nomify.Resources.create_person()

    person
  end

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
  def team_member_fixture(attrs \\ %{}) do
    # NOTE: Pass associated structs or create them
    team = team_fixture()
    person = person_fixture()

    attrs =
      Enum.into(attrs, %{
        privileges: 42,
        security_level: :low,
        team_role: :admin
      })

    {:ok, team_member} = Nomify.Resources.create_team_member(team, person, attrs)

    team_member
  end
end
