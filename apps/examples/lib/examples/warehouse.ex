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
end
