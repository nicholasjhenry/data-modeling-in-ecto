defmodule Examples.ComputerStore do
  @moduledoc """
  The ComputerStore context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.ComputerStore.System

  def get_system!(id), do: Repo.get!(System, id)

  def create_system(attrs \\ %{}) do
    %System{}
    |> System.changeset(attrs)
    |> Repo.insert()
  end

  def update_system(%System{} = system, attrs) do
    system
    |> System.changeset(attrs)
    |> Repo.update()
  end

  alias Examples.ComputerStore.Component

  def get_component!(id), do: Repo.get!(Component, id)

  def create_component(attrs \\ %{}) do
    %Component{}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  def update_component(%Component{} = component, attrs) do
    component
    |> Component.changeset(attrs)
    |> Repo.update()
  end
end
