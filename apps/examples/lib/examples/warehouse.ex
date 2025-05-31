defmodule Examples.Warehouse do
  @moduledoc """
  The Warehouse context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.Warehouse.LoadingArea

  def get_loading_area!(id), do: Repo.get!(LoadingArea, id)

  def create_loading_area(attrs \\ %{}) do
    %LoadingArea{}
    |> LoadingArea.changeset(attrs)
    |> Repo.insert()
  end

  def update_loading_area(%LoadingArea{} = loading_area, attrs) do
    loading_area
    |> LoadingArea.changeset(attrs)
    |> Repo.update()
  end

  alias Examples.Warehouse.LoadingBin

  @doc """
  Returns the list of warehouse_loading_bins.

  ## Examples

      iex> list_warehouse_loading_bins()
      [%LoadingBin{}, ...]

  """
  def list_warehouse_loading_bins do
    Repo.all(LoadingBin)
  end

  @doc """
  Gets a single loading_bin.

  Raises `Ecto.NoResultsError` if the Loading bin does not exist.

  ## Examples

      iex> get_loading_bin!(123)
      %LoadingBin{}

      iex> get_loading_bin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loading_bin!(id), do: Repo.get!(LoadingBin, id)

  @doc """
  Creates a loading_bin.

  ## Examples

      iex> create_loading_bin(%{field: value})
      {:ok, %LoadingBin{}}

      iex> create_loading_bin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loading_bin(attrs \\ %{}) do
    %LoadingBin{}
    |> LoadingBin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loading_bin.

  ## Examples

      iex> update_loading_bin(loading_bin, %{field: new_value})
      {:ok, %LoadingBin{}}

      iex> update_loading_bin(loading_bin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loading_bin(%LoadingBin{} = loading_bin, attrs) do
    loading_bin
    |> LoadingBin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loading_bin.

  ## Examples

      iex> delete_loading_bin(loading_bin)
      {:ok, %LoadingBin{}}

      iex> delete_loading_bin(loading_bin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loading_bin(%LoadingBin{} = loading_bin) do
    Repo.delete(loading_bin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loading_bin changes.

  ## Examples

      iex> change_loading_bin(loading_bin)
      %Ecto.Changeset{data: %LoadingBin{}}

  """
  def change_loading_bin(%LoadingBin{} = loading_bin, attrs \\ %{}) do
    LoadingBin.changeset(loading_bin, attrs)
  end
end
