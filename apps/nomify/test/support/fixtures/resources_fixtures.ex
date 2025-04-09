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
        email: "some email",
        name: "some name",
        title: "some title"
      })
      |> Nomify.Resources.create_person()

    person
  end
end
