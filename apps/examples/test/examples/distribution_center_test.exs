defmodule Examples.DistributionCenterTest do
  use Examples.DataCase

  alias Examples.DistributionCenter

  describe "distribution_center_pallets" do
    alias Examples.DistributionCenter.Pallet

    import Examples.DistributionCenterFixtures

    @invalid_attrs %{
      type: nil,
      state: nil,
      max_weight: nil,
      scheduled_to_load_at: nil
    }

    test "get_pallet!/1 returns the pallet with given id" do
      pallet = pallet_fixture()
      assert DistributionCenter.get_pallet!(pallet.id) == pallet
    end

    test "create_pallet/1 with valid data creates a pallet" do
      valid_attrs = %{
        max_weight: "120.5",
        scheduled_to_load_at: ~N[2025-06-03 15:55:00]
      }

      assert {:ok, %Pallet{} = pallet} = DistributionCenter.create_pallet(valid_attrs)
      assert pallet.type == :non_refrigerated
      assert pallet.state == :pending
      assert Decimal.equal?(pallet.max_weight, Decimal.new("120.5"))
      assert pallet.scheduled_to_load_at == ~N[2025-06-03 15:55:00]
    end

    test "create_pallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DistributionCenter.create_pallet(@invalid_attrs)
    end
  end

  describe "distribution_center_cases" do
    alias Examples.DistributionCenter.Case

    import Examples.DistributionCenterFixtures

    @invalid_attrs %{state: nil, pallet_requirement: nil, weight: nil, service_type: nil}

    test "get_case!/1 returns the case with given id" do
      case = case_fixture()
      assert DistributionCenter.get_case!(case.id) == case
    end

    test "create_case/1 with valid data creates a case" do
      valid_attrs = %{
        weight: "120.5"
      }

      assert {:ok, %Case{} = case} = DistributionCenter.create_case(valid_attrs)
      assert case.state == :empty
      assert case.pallet_requirement == :non_refrigerated
      assert Decimal.equal?(case.weight, Decimal.new("120.5"))
      assert case.service_type == :regular
    end

    test "create_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DistributionCenter.create_case(@invalid_attrs)
    end
  end

  describe "distribution_center_pallets and distribution_center_cases" do
    alias Examples.DistributionCenter.Pallet

    import Examples.DistributionCenterFixtures

    test "load case in pallet" do
      case = case_fixture()
      pallet = pallet_fixture()

      assert {:ok, %Pallet{} = pallet} = DistributionCenter.load_case_in_pallet(pallet, case)
      assert List.first(pallet.cases).id == case.id
    end

    test "validates pallet type" do
      case = case_fixture(pallet_requirement: :refrigerated)
      pallet = pallet_fixture(type: :non_refrigerated)

      assert {:error, changeset} = DistributionCenter.load_case_in_pallet(pallet, case)
      assert "Pallet type meet case requirements" in errors_on(changeset).business_rule
    end

    test "validate case count" do
      case = case_fixture()
      another_case = case_fixture()
      pallet = pallet_fixture()

      assert {:ok, pallet} = DistributionCenter.load_case_in_pallet(pallet, case)

      assert {:error, changeset} =
               DistributionCenter.load_case_in_pallet(pallet, another_case, max_case_count: 1)

      assert "Pallet exceeds capacity" in errors_on(changeset).business_rule
    end

    test "validate case can be placed on at most one pallet" do
      case = case_fixture()
      pallet = pallet_fixture()
      another_pallet = pallet_fixture()

      assert {:ok, _pallet} = DistributionCenter.load_case_in_pallet(pallet, case)

      case = DistributionCenter.get_case!(case.id)

      assert {:error, changeset} =
               DistributionCenter.load_case_in_pallet(another_pallet, case)

      assert "Case already assigned to a pallet" in errors_on(changeset).business_rule
    end
  end
end
