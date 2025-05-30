defmodule Examples.Warehouse do
  @moduledoc """
  The Warehouse context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.Warehouse.LoadingArea

  @doc """
  Returns the list of warehouse_loading_areas.

  ## Examples

      iex> list_warehouse_loading_areas()
      [%LoadingArea{}, ...]

  """
  def list_warehouse_loading_areas do
    Repo.all(LoadingArea)
  end

  @doc """
  Gets a single loading_area.

  Raises `Ecto.NoResultsError` if the Loading area does not exist.

  ## Examples

      iex> get_loading_area!(123)
      %LoadingArea{}

      iex> get_loading_area!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loading_area!(id), do: Repo.get!(LoadingArea, id)

  @doc """
  Creates a loading_area.

  ## Examples

      iex> create_loading_area(%{field: value})
      {:ok, %LoadingArea{}}

      iex> create_loading_area(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loading_area(attrs \\ %{}) do
    %LoadingArea{}
    |> LoadingArea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loading_area.

  ## Examples

      iex> update_loading_area(loading_area, %{field: new_value})
      {:ok, %LoadingArea{}}

      iex> update_loading_area(loading_area, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loading_area(%LoadingArea{} = loading_area, attrs) do
    loading_area
    |> LoadingArea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loading_area.

  ## Examples

      iex> delete_loading_area(loading_area)
      {:ok, %LoadingArea{}}

      iex> delete_loading_area(loading_area)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loading_area(%LoadingArea{} = loading_area) do
    Repo.delete(loading_area)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loading_area changes.

  ## Examples

      iex> change_loading_area(loading_area)
      %Ecto.Changeset{data: %LoadingArea{}}

  """
  def change_loading_area(%LoadingArea{} = loading_area, attrs \\ %{}) do
    LoadingArea.changeset(loading_area, attrs)
  end
end
