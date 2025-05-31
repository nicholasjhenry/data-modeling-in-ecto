defmodule Examples.Warehouse do
  @moduledoc """
  The Warehouse context.
  """

  import Ecto.Query, warn: false
  alias Examples.Warehouse.LoadingBin
  alias Examples.Repo

  alias Examples.Warehouse.LoadingArea

  def get_loading_area!(id), do: Repo.get!(LoadingArea, id)

  def create_loading_area(%LoadingBin{} = loading_bin, attrs \\ %{}) do
    %LoadingArea{}
    |> LoadingArea.changeset(attrs)
    |> LoadingArea.put_loading_bin(loading_bin)
    |> Repo.insert()
  end

  def update_loading_area(%LoadingArea{} = loading_area, attrs) do
    loading_area
    |> LoadingArea.changeset(attrs)
    |> Repo.update()
  end

  def loading_area_equal?(%LoadingArea{} = loading_area1, %LoadingArea{} = loading_area2) do
    loading_area1.type == loading_area2.type &&
      Decimal.equal?(loading_area1.size, loading_area2.size) &&
      Decimal.equal?(loading_area1.average_temperature, loading_area2.average_temperature) &&
      loading_area1.state == loading_area2.state
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
