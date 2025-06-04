defmodule Examples.DistributionCenterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.DistributionCenter` context.
  """

  @doc """
  Generate a pallet.
  """
  def pallet_fixture(attrs \\ %{}) do
    {:ok, pallet} =
      attrs
      |> Enum.into(%{
        max_weight: "120.5",
        scheduled_to_load_at: ~N[2025-06-03 15:55:00],
        type: :refrigerated
      })
      |> Examples.DistributionCenter.create_pallet()

    pallet
  end

  @doc """
  Generate a case.
  """
  def case_fixture(attrs \\ %{}) do
    {:ok, case} =
      attrs
      |> Enum.into(%{
        pallet_requirement: :refrigerated,
        service_type: :regular,
        weight: "120.5"
      })
      |> Examples.DistributionCenter.create_case()

    case
  end

  def full_case_fixture(attrs \\ %{}) do
    {:ok, case} =
      attrs
      |> case_fixture()
      |> Examples.DistributionCenter.flag_as_full()

    case
  end
end
