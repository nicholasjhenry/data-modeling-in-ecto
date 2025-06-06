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
end
