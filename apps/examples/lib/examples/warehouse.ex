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

  def get_loading_bin!(id), do: Repo.get!(LoadingBin, id)

  def create_loading_bin(attrs \\ %{}) do
    %LoadingBin{}
    |> LoadingBin.changeset(attrs)
    |> Repo.insert()
  end

  def update_loading_bin(%LoadingBin{} = loading_bin, attrs) do
    loading_bin
    |> LoadingBin.changeset(attrs)
    |> Repo.update()
  end
end
