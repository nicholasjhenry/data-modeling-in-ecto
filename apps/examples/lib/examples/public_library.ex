defmodule Examples.PublicLibrary do
  @moduledoc """
  The PublicLibrary context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.PublicLibrary.Branch

  def get_branch!(id, preloads \\ []) do
    Branch
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.PublicLibrary.Resource

  def get_resource!(id, preloads \\ []) do
    Resource
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.PublicLibrary.Person

  def get_person!(id, preloads \\ []) do
    Person
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.PublicLibrary.Patron

  def get_patron!(id, preloads \\ []) do
    Patron
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def get_patron_with_computed!(id) do
    Patron
    |> Patron.base_query()
    |> Repo.get!(id)
    |> Patron.determine_max_resource_hold_count()
  end

  def create_patron(person, attrs \\ %{}) do
    with {:ok, %{id: id}} <-
           %Patron{}
           |> Patron.changeset(attrs)
           |> Patron.put_person_changeset(person)
           |> Repo.insert(returning: [:id]) do
      {:ok, get_patron_with_computed!(id)}
    end
  end

  def deactivate_patron(patron) do
    patron
    |> Patron.deactivate_changeset()
    |> Repo.update()
  end

  def patron_equal?(patron1, patron2) do
    patron1.id == patron2.id and
      patron1.name == patron2.name and
      Date.compare(patron1.born_on, patron2.born_on) == :eq
  end

  alias Examples.PublicLibrary.ResourceHold

  def get_resource_hold!(id, preloads \\ []) do
    ResourceHold
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def create_resource_hold(
        %Resource{} = resource,
        %Branch{} = branch,
        %Patron{} = patron,
        attrs \\ %{},
        opts \\ []
      ) do
    patron =
      patron
      |> Repo.preload(:resource_holds)
      |> Patron.determine_max_resource_hold_count(opts)
      |> Patron.calculate_resource_hold_count()
      |> Patron.determine_age_group(opts)

    %ResourceHold{}
    |> ResourceHold.changeset(attrs)
    |> ResourceHold.put_resource_changeset(resource)
    |> ResourceHold.put_branch_changeset(branch)
    |> ResourceHold.put_patron_changeset(patron)
    |> Repo.insert()
  end

  def place_hold_on_resource(
        %Resource{} = resource,
        %Branch{} = branch,
        %Patron{} = patron,
        attrs \\ %{},
        opts \\ []
      ),
      do: create_resource_hold(resource, branch, patron, attrs, opts)
end
