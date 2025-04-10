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
end
