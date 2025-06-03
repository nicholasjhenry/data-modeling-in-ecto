defmodule Examples.ComputerStoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.ComputerStore` context.
  """

  @doc """
  Generate a system.
  """
  def system_fixture(component \\ component_fixture(), attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        approval_state: :pending,
        electrical_requirements: :domestic,
        price: "120.5",
        type: :server,
        weight: "120.5"
      })

    {:ok, system} = Examples.ComputerStore.create_system(component, attrs)

    system
  end

  @doc """
  Generate a component.
  """
  def component_fixture(attrs \\ %{}) do
    {:ok, component} =
      attrs
      |> Enum.into(%{
        approval_state: :operational,
        electrical_requirements: :domestic,
        price: "120.5",
        system_type: :server,
        weight: "120.5"
      })
      |> Examples.ComputerStore.create_component()

    component
  end
end
