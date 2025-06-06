defmodule Examples.PublicLibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.PublicLibrary` context.
  """

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Examples.PublicLibrary.create_branch()

    branch
  end

  @doc """
  Generate a resource.
  """
  def resource_fixture(attrs \\ %{}) do
    {:ok, resource} =
      attrs
      |> Enum.into(%{
        has_fee: true
      })
      |> Examples.PublicLibrary.create_resource()

    resource
  end

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        born_on: ~D[2025-06-05],
        name: "some name"
      })
      |> Examples.PublicLibrary.create_person()

    person
  end

  @doc """
  Generate a unique patron registration_number.
  """
  def unique_patron_registration_number,
    do: "some registration_number#{System.unique_integer([:positive])}"

  @doc """
  Generate a patron.
  """
  def patron_fixture(person \\ person_fixture(), attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        registration_number: unique_patron_registration_number(),
        state: :active,
        type: :regular
      })

    {:ok, patron} = Examples.PublicLibrary.create_patron(person, attrs)

    patron
  end
end
