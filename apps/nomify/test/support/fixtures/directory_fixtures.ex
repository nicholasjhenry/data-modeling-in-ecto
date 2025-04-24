defmodule Nomify.DirectoryFixtures do
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
      |> Nomify.Directory.create_person()

    person
  end

  def valid_person_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: "some name",
      title: "some title"
    })
  end
end
