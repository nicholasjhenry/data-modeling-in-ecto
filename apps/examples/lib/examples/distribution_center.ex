defmodule Examples.DistributionCenter do
  @moduledoc """
  The DistributionCenter context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.DistributionCenter.Pallet

  @doc """
  Returns the list of distribution_center_pallets.

  ## Examples

      iex> list_distribution_center_pallets()
      [%Pallet{}, ...]

  """
  def list_distribution_center_pallets do
    Repo.all(Pallet)
  end

  @doc """
  Gets a single pallet.

  Raises `Ecto.NoResultsError` if the Pallet does not exist.

  ## Examples

      iex> get_pallet!(123)
      %Pallet{}

      iex> get_pallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pallet!(id), do: Repo.get!(Pallet, id)

  @doc """
  Creates a pallet.

  ## Examples

      iex> create_pallet(%{field: value})
      {:ok, %Pallet{}}

      iex> create_pallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pallet(attrs \\ %{}) do
    %Pallet{}
    |> Pallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pallet.

  ## Examples

      iex> update_pallet(pallet, %{field: new_value})
      {:ok, %Pallet{}}

      iex> update_pallet(pallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pallet(%Pallet{} = pallet, attrs) do
    pallet
    |> Pallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pallet.

  ## Examples

      iex> delete_pallet(pallet)
      {:ok, %Pallet{}}

      iex> delete_pallet(pallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pallet(%Pallet{} = pallet) do
    Repo.delete(pallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pallet changes.

  ## Examples

      iex> change_pallet(pallet)
      %Ecto.Changeset{data: %Pallet{}}

  """
  def change_pallet(%Pallet{} = pallet, attrs \\ %{}) do
    Pallet.changeset(pallet, attrs)
  end
end
