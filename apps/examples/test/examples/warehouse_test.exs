defmodule Examples.WarehouseTest do
  alias PgRanges.NumRange
  use Examples.DataCase

  alias Examples.Warehouse

  describe "warehouse_loading_areas" do
    alias Examples.Warehouse.LoadingArea

    import Examples.WarehouseFixtures

    @invalid_attrs %{size: nil, type: nil, state: nil, average_temperature: nil}

    test "get_loading_area!/1 returns the loading_area with given id" do
      loading_area = loading_area_fixture()

      assert Warehouse.loading_area_equal?(
               Warehouse.get_loading_area!(loading_area.id),
               loading_area
             )
    end

    test "create_loading_area/1 with valid data creates a loading_area" do
      loading_bin = loading_bin_fixture()

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "20"
      }

      assert {:ok, %LoadingArea{} = loading_area} =
               Warehouse.create_loading_area(loading_bin, valid_attrs)

      assert loading_area.size == Decimal.new("100")
      assert loading_area.type == :room_temperature
      assert loading_area.state == :static
      assert loading_area.average_temperature == Decimal.new("20")
    end

    test "create_loading_area/1 with invalid data returns error changeset" do
      loading_bin = loading_bin_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Warehouse.create_loading_area(loading_bin, @invalid_attrs)
    end

    test "update_loading_area/2 with valid data updates the loading_area" do
      loading_area = loading_area_fixture()

      update_attrs = %{
        size: "456.7",
        type: :refrigerated,
        state: :receiving,
        average_temperature: "456.7"
      }

      assert {:ok, %LoadingArea{} = loading_area} =
               Warehouse.update_loading_area(loading_area, update_attrs)

      assert loading_area.size == Decimal.new("456.7")
      assert loading_area.type == :refrigerated
      assert loading_area.state == :receiving
      assert loading_area.average_temperature == Decimal.new("456.7")
    end

    test "update_loading_area/2 with invalid data returns error changeset" do
      loading_area = loading_area_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Warehouse.update_loading_area(loading_area, @invalid_attrs)

      assert Warehouse.loading_area_equal?(
               loading_area,
               Warehouse.get_loading_area!(loading_area.id)
             )
    end
  end

  describe "warehouse_loading_bins" do
    alias Examples.Warehouse.LoadingBin
    alias PgRanges.NumRange

    import Examples.WarehouseFixtures

    @invalid_attrs %{size: nil, state: nil, acceptable_temperature_range: nil, designation: nil}

    test "get_loading_bin!/1 returns the loading_bin with given id" do
      loading_bin = loading_bin_fixture()
      assert Warehouse.get_loading_bin!(loading_bin.id) == loading_bin
    end

    test "create_loading_bin/1 with valid data creates a loading_bin" do
      valid_attrs = %{
        size: "120.5",
        state: :empty,
        acceptable_temperature_range: NumRange.new(1, 100),
        designation: :food
      }

      assert {:ok, %LoadingBin{} = loading_bin} = Warehouse.create_loading_bin(valid_attrs)
      assert loading_bin.size == Decimal.new("120.5")
      assert loading_bin.state == :empty
      assert NumRange.equal?(loading_bin.acceptable_temperature_range, NumRange.new(1, 100))
      assert loading_bin.designation == :food
    end

    test "create_loading_bin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehouse.create_loading_bin(@invalid_attrs)
    end

    test "update_loading_bin/2 with valid data updates the loading_bin" do
      loading_bin = loading_bin_fixture()

      update_attrs = %{
        size: "456.7",
        state: :full,
        acceptable_temperature_range: NumRange.new(100, 200),
        designation: :toxic_materials
      }

      assert {:ok, %LoadingBin{} = loading_bin} =
               Warehouse.update_loading_bin(loading_bin, update_attrs)

      assert loading_bin.size == Decimal.new("456.7")
      assert loading_bin.state == :full
      assert NumRange.equal?(loading_bin.acceptable_temperature_range, NumRange.new(100, 200))
      assert loading_bin.designation == :toxic_materials
    end

    test "update_loading_bin/2 with invalid data returns error changeset" do
      loading_bin = loading_bin_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Warehouse.update_loading_bin(loading_bin, @invalid_attrs)

      assert loading_bin == Warehouse.get_loading_bin!(loading_bin.id)
    end
  end

  describe "warehouse_loading_areas and warehouse_loading_bins" do
    alias Examples.Warehouse.LoadingArea
    alias Examples.Warehouse.LoadingBin

    import Examples.WarehouseFixtures

    test "loading area contains at least one loading bin" do
      loading_bin = loading_bin_fixture()

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "20"
      }

      assert {:ok, %LoadingArea{} = loading_area} =
               Warehouse.create_loading_area(loading_bin, valid_attrs)

      assert List.first(loading_area.loading_bins).id == loading_bin.id
    end

    test "loading bin is always within one loading area, being moved between loading areas, or not in use" do
      loading_bin = loading_bin_fixture()

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "20"
      }

      assert {:ok, %LoadingArea{} = loading_area} =
               Warehouse.create_loading_area(loading_bin, valid_attrs)

      loading_bin = Warehouse.get_loading_bin!(loading_bin.id)
      assert {:error, changeset} = Warehouse.remove_loading_bin(loading_area, loading_bin)

      assert "Loading area requires at least one loading bin" in errors_on(changeset).business_rule

      another_loading_bin = loading_bin_fixture()

      assert {:ok, relocated_loading_bin} =
               Warehouse.relocate_loading_bin(loading_area, another_loading_bin)

      loading_area = Warehouse.get_loading_area!(loading_area.id)
      assert Warehouse.loading_bin_located?(loading_area, relocated_loading_bin)

      assert {:ok, relocated_loading_bin} =
               Warehouse.remove_loading_bin(loading_area, relocated_loading_bin)

      loading_area = Warehouse.get_loading_area!(loading_area.id)
      refute Warehouse.loading_bin_located?(loading_area, relocated_loading_bin)
    end

    test "loading area cannot add a loading bin whose size is greater than its available space" do
      oversize_loading_bin = loading_bin_fixture(size: 200)

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "20"
      }

      assert {:error, changeset} =
               Warehouse.create_loading_area(oversize_loading_bin, valid_attrs)

      assert "Loading area size is too small" in errors_on(changeset).business_rule

      loading_bin = loading_bin_fixture(size: 50)

      assert {:ok, loading_area} =
               Warehouse.create_loading_area(loading_bin, valid_attrs)

      another_loading_bin = loading_bin_fixture(size: 50)

      assert {:ok, _loading_area} =
               Warehouse.relocate_loading_bin(loading_area, another_loading_bin)

      assert {:error, changeset} =
               Warehouse.relocate_loading_bin(loading_area, oversize_loading_bin)

      assert "Loading area size is too small" in errors_on(changeset).business_rule
    end

    test "loading bin cannot exist in a loading area whose average temperature is not within its acceptable temperature range" do
      loading_bin =
        loading_bin_fixture(acceptable_temperature_range: NumRange.new("10", "30"))

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "40"
      }

      assert {:error, changeset} =
               Warehouse.create_loading_area(loading_bin, valid_attrs)

      assert "Loading area exceeds loading bins acceptable temperature range" in errors_on(
               changeset
             ).business_rule

      valid_attrs = %{
        size: "100",
        type: :room_temperature,
        state: :static,
        average_temperature: "20"
      }

      assert {:ok, loading_area} = Warehouse.create_loading_area(loading_bin, valid_attrs)

      loading_bin = loading_bin_fixture(acceptable_temperature_range: NumRange.new("0", "10"))

      assert {:error, changeset} = Warehouse.relocate_loading_bin(loading_area, loading_bin)

      assert "Loading area exceeds loading bins acceptable temperature range" in errors_on(
               changeset
             ).business_rule
    end
  end
end
