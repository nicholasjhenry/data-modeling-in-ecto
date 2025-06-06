defmodule Examples.PublicLibrary do
  @moduledoc """
  The PublicLibrary context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.PublicLibrary.Branch

  def get_branch!(id), do: Repo.get!(Branch, id)

  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.PublicLibrary.Resource

  def get_resource!(id), do: Repo.get!(Resource, id)

  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end
end
