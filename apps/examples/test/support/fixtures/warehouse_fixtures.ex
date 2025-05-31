defmodule Examples.WarehouseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.Warehouse` context.
  """

  @doc """
  Generate a loading_area.
  """
  def loading_area_fixture(attrs \\ %{}) do
    {:ok, loading_area} =
      attrs
      |> Enum.into(%{
        average_temperature: "120.5",
        size: "120.5",
        state: :static,
        type: :room_temperature
      })
      |> Examples.Warehouse.create_loading_area()

    loading_area
  end

  @doc """
  Generate a loading_bin.
  """
  def loading_bin_fixture(attrs \\ %{}) do
    {:ok, loading_bin} =
      attrs
      |> Enum.into(%{
        acceptable_temperature_range: "some acceptable_temperature_range",
        designation: :food,
        size: "120.5",
        state: :empty
      })
      |> Examples.Warehouse.create_loading_bin()

    loading_bin
  end
end
