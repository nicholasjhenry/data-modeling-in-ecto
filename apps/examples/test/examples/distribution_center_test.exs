defmodule Examples.DistributionCenterTest do
  use Examples.DataCase

  alias Examples.DistributionCenter

  describe "distribution_center_pallets" do
    alias Examples.DistributionCenter.Pallet

    import Examples.DistributionCenterFixtures

    @invalid_attrs %{
      type: nil,
      state: nil,
      max_cases: nil,
      max_weight: nil,
      scheduled_to_load_at: nil
    }

    test "get_pallet!/1 returns the pallet with given id" do
      pallet = pallet_fixture()
      assert DistributionCenter.get_pallet!(pallet.id) == pallet
    end

    test "create_pallet/1 with valid data creates a pallet" do
      valid_attrs = %{
        type: :refrigerated,
        state: :pending,
        max_cases: 42,
        max_weight: "120.5",
        scheduled_to_load_at: ~N[2025-06-03 15:55:00]
      }

      assert {:ok, %Pallet{} = pallet} = DistributionCenter.create_pallet(valid_attrs)
      assert pallet.type == :refrigerated
      assert pallet.state == :pending
      assert pallet.max_cases == 42
      assert pallet.max_weight == Decimal.new("120.5")
      assert pallet.scheduled_to_load_at == ~N[2025-06-03 15:55:00]
    end

    test "create_pallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DistributionCenter.create_pallet(@invalid_attrs)
    end
  end

  describe "distribution_center_cases" do
    alias Examples.DistributionCenter.Case

    import Examples.DistributionCenterFixtures

    @invalid_attrs %{state: nil, pallet_type: nil, weight: nil, service_type: nil}

    test "get_case!/1 returns the case with given id" do
      case = case_fixture()
      assert DistributionCenter.get_case!(case.id) == case
    end

    test "create_case/1 with valid data creates a case" do
      valid_attrs = %{
        state: :empty,
        pallet_type: :refrigerated,
        weight: "120.5",
        service_type: :regular
      }

      assert {:ok, %Case{} = case} = DistributionCenter.create_case(valid_attrs)
      assert case.state == :empty
      assert case.pallet_type == :refrigerated
      assert case.weight == Decimal.new("120.5")
      assert case.service_type == :regular
    end

    test "create_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DistributionCenter.create_case(@invalid_attrs)
    end
  end
end
