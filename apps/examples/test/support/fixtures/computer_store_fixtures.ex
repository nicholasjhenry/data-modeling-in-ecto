defmodule Examples.ComputerStoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.ComputerStore` context.
  """

  @doc """
  Generate a system.
  """
  def system_fixture(attrs \\ %{}) do
    {:ok, system} =
      attrs
      |> Enum.into(%{
        approval_state: :pending,
        electrical_requirements: :domestic,
        price: "120.5",
        type: :server,
        weight: "120.5"
      })
      |> Examples.ComputerStore.create_system()

    system
  end
end
