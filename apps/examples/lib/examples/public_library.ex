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

  @doc """
  Returns the list of public_library_resource_holds.

  ## Examples

      iex> list_public_library_resource_holds()
      [%ResourceHold{}, ...]

  """
  def list_public_library_resource_holds do
    Repo.all(ResourceHold)
  end

  @doc """
  Gets a single resource_hold.

  Raises `Ecto.NoResultsError` if the Resource hold does not exist.

  ## Examples

      iex> get_resource_hold!(123)
      %ResourceHold{}

      iex> get_resource_hold!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource_hold!(id), do: Repo.get!(ResourceHold, id)

  @doc """
  Creates a resource_hold.

  ## Examples

      iex> create_resource_hold(%{field: value})
      {:ok, %ResourceHold{}}

      iex> create_resource_hold(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource_hold(attrs \\ %{}) do
    %ResourceHold{}
    |> ResourceHold.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resource_hold.

  ## Examples

      iex> update_resource_hold(resource_hold, %{field: new_value})
      {:ok, %ResourceHold{}}

      iex> update_resource_hold(resource_hold, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource_hold(%ResourceHold{} = resource_hold, attrs) do
    resource_hold
    |> ResourceHold.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a resource_hold.

  ## Examples

      iex> delete_resource_hold(resource_hold)
      {:ok, %ResourceHold{}}

      iex> delete_resource_hold(resource_hold)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource_hold(%ResourceHold{} = resource_hold) do
    Repo.delete(resource_hold)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource_hold changes.

  ## Examples

      iex> change_resource_hold(resource_hold)
      %Ecto.Changeset{data: %ResourceHold{}}

  """
  def change_resource_hold(%ResourceHold{} = resource_hold, attrs \\ %{}) do
    ResourceHold.changeset(resource_hold, attrs)
  end
end
