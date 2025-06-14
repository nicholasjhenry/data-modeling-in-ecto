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
        has_fee: false
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
        born_on: ~D[1970-01-01],
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
        type: :regular
      })

    {:ok, patron} = Examples.PublicLibrary.create_patron(person, attrs)

    patron
  end

  @doc """
  Generate a resource_hold.
  """
  def resource_hold_fixture(
        branch \\ branch_fixture(),
        resource \\ resource_fixture(),
        patron \\ patron_fixture(),
        attrs \\ %{}
      ) do
    attrs =
      Enum.into(attrs, %{
        permit_resource_fees: false,
        type: :open_ended,
        pickup_day: "Monday"
      })

    {:ok, resource_hold} =
      Examples.PublicLibrary.create_resource_hold(branch, resource, patron, attrs)

    resource_hold
  end
end
