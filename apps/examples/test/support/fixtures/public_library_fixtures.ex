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
end
