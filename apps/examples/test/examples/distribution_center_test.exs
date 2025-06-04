defmodule Examples.DistributionCenterTest do
  use Examples.DataCase

  alias Examples.DistributionCenter

  describe "distribution_center_pallets" do
    alias Examples.DistributionCenter.Pallet

    import Examples.DistributionCenterFixtures

    @invalid_attrs %{type: nil, state: nil, max_cases: nil, max_weight: nil, scheduled_to_load_at: nil}

    test "list_distribution_center_pallets/0 returns all distribution_center_pallets" do
      pallet = pallet_fixture()
      assert DistributionCenter.list_distribution_center_pallets() == [pallet]
    end

    test "get_pallet!/1 returns the pallet with given id" do
      pallet = pallet_fixture()
      assert DistributionCenter.get_pallet!(pallet.id) == pallet
    end

    test "create_pallet/1 with valid data creates a pallet" do
      valid_attrs = %{type: :refrigerated, state: :pending, max_cases: 42, max_weight: "120.5", scheduled_to_load_at: ~N[2025-06-03 15:55:00]}

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

    test "update_pallet/2 with valid data updates the pallet" do
      pallet = pallet_fixture()
      update_attrs = %{type: :non_refrigerated, state: :loaded, max_cases: 43, max_weight: "456.7", scheduled_to_load_at: ~N[2025-06-04 15:55:00]}

      assert {:ok, %Pallet{} = pallet} = DistributionCenter.update_pallet(pallet, update_attrs)
      assert pallet.type == :non_refrigerated
      assert pallet.state == :loaded
      assert pallet.max_cases == 43
      assert pallet.max_weight == Decimal.new("456.7")
      assert pallet.scheduled_to_load_at == ~N[2025-06-04 15:55:00]
    end

    test "update_pallet/2 with invalid data returns error changeset" do
      pallet = pallet_fixture()
      assert {:error, %Ecto.Changeset{}} = DistributionCenter.update_pallet(pallet, @invalid_attrs)
      assert pallet == DistributionCenter.get_pallet!(pallet.id)
    end

    test "delete_pallet/1 deletes the pallet" do
      pallet = pallet_fixture()
      assert {:ok, %Pallet{}} = DistributionCenter.delete_pallet(pallet)
      assert_raise Ecto.NoResultsError, fn -> DistributionCenter.get_pallet!(pallet.id) end
    end

    test "change_pallet/1 returns a pallet changeset" do
      pallet = pallet_fixture()
      assert %Ecto.Changeset{} = DistributionCenter.change_pallet(pallet)
    end
  end
end
