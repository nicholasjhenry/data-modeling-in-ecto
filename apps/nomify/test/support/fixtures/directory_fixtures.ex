defmodule Nomify.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Resources` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        email: "foo@example.com",
        name: "some name",
        title: "some title"
      })

    {:ok, person} = Nomify.Directory.create_person(scope, attrs)

    person
  end
end
