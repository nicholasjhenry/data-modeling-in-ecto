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

  alias Examples.PublicLibrary.Person

  def get_person!(id), do: Repo.get!(Person, id)

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.PublicLibrary.Patron

  def get_patron!(id) do
    Patron
    |> Patron.base_query()
    |> Repo.get!(id)
  end

  def create_patron(person, attrs \\ %{}) do
    with {:ok, %{id: id}} <-
           %Patron{}
           |> Patron.changeset(attrs)
           |> Patron.put_person_changeset(person)
           |> Repo.insert(returning: [:id]) do
      {:ok, get_patron!(id)}
    end
  end

  def patron_equal?(patron1, patron2) do
    patron1.id == patron2.id and
      patron1.name == patron2.name and
      Date.compare(patron1.born_on, patron2.born_on) == :eq
  end

  alias Examples.PublicLibrary.ResourceHold

  def get_resource_hold!(id), do: Repo.get!(ResourceHold, id)

  def create_resource_hold(branch, attrs \\ %{}) do
    %ResourceHold{}
    |> ResourceHold.changeset(attrs)
    |> ResourceHold.put_branch_changeset(branch)
    |> Repo.insert()
  end
end
