defmodule Examples.ComputerStore do
  @moduledoc """
  The ComputerStore context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.ComputerStore.System

  def get_system!(id) do
    System
    |> Repo.get!(id)
    |> Repo.preload(:components)
  end

  def create_system(component, attrs \\ %{}) do
    %System{}
    |> System.changeset(attrs)
    |> System.put_component_changeset(component)
    |> Repo.insert()
  end

  def update_system(%System{} = system, attrs) do
    system
    |> System.changeset(attrs)
    |> Repo.update()
  end

  def approve_system(%System{} = system) do
    system
    |> System.approval_completed_changeset()
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

  def add_component_to_system(system, component) do
    system
    |> Repo.preload(:components)
    |> System.put_component_changeset(component)
    |> Repo.update()
  end

  def remove_component_from_system(system, component) do
    system
    |> Repo.preload(:components)
    |> System.remove_component_changeset(component)
    |> Repo.update()
  end

  def contains_component?(system, component) do
    Enum.any?(system.components, &(&1.id == component.id))
  end
end
