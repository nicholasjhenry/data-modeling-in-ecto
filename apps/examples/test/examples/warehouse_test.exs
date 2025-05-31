defmodule Examples.WarehouseTest do
  use Examples.DataCase

  alias Examples.Warehouse

  describe "warehouse_loading_areas" do
    alias Examples.Warehouse.LoadingArea

    import Examples.WarehouseFixtures

    @invalid_attrs %{size: nil, type: nil, state: nil, average_temperature: nil}

    test "get_loading_area!/1 returns the loading_area with given id" do
      loading_area = loading_area_fixture()
      assert Warehouse.get_loading_area!(loading_area.id) == loading_area
    end

    test "create_loading_area/1 with valid data creates a loading_area" do
      valid_attrs = %{
        size: "120.5",
        type: :room_temperature,
        state: :static,
        average_temperature: "120.5"
      }

      assert {:ok, %LoadingArea{} = loading_area} = Warehouse.create_loading_area(valid_attrs)
      assert loading_area.size == Decimal.new("120.5")
      assert loading_area.type == :room_temperature
      assert loading_area.state == :static
      assert loading_area.average_temperature == Decimal.new("120.5")
    end

    test "create_loading_area/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehouse.create_loading_area(@invalid_attrs)
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

      assert loading_area == Warehouse.get_loading_area!(loading_area.id)
    end
  end

  describe "warehouse_loading_bins" do
    alias Examples.Warehouse.LoadingBin

    import Examples.WarehouseFixtures

    @invalid_attrs %{size: nil, state: nil, acceptable_temperature_range: nil, designation: nil}

    test "list_warehouse_loading_bins/0 returns all warehouse_loading_bins" do
      loading_bin = loading_bin_fixture()
      assert Warehouse.list_warehouse_loading_bins() == [loading_bin]
    end

    test "get_loading_bin!/1 returns the loading_bin with given id" do
      loading_bin = loading_bin_fixture()
      assert Warehouse.get_loading_bin!(loading_bin.id) == loading_bin
    end

    test "create_loading_bin/1 with valid data creates a loading_bin" do
      valid_attrs = %{size: "120.5", state: :empty, acceptable_temperature_range: "some acceptable_temperature_range", designation: :food}

      assert {:ok, %LoadingBin{} = loading_bin} = Warehouse.create_loading_bin(valid_attrs)
      assert loading_bin.size == Decimal.new("120.5")
      assert loading_bin.state == :empty
      assert loading_bin.acceptable_temperature_range == "some acceptable_temperature_range"
      assert loading_bin.designation == :food
    end

    test "create_loading_bin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehouse.create_loading_bin(@invalid_attrs)
    end

    test "update_loading_bin/2 with valid data updates the loading_bin" do
      loading_bin = loading_bin_fixture()
      update_attrs = %{size: "456.7", state: :full, acceptable_temperature_range: "some updated acceptable_temperature_range", designation: :toxic_materials}

      assert {:ok, %LoadingBin{} = loading_bin} = Warehouse.update_loading_bin(loading_bin, update_attrs)
      assert loading_bin.size == Decimal.new("456.7")
      assert loading_bin.state == :full
      assert loading_bin.acceptable_temperature_range == "some updated acceptable_temperature_range"
      assert loading_bin.designation == :toxic_materials
    end

    test "update_loading_bin/2 with invalid data returns error changeset" do
      loading_bin = loading_bin_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehouse.update_loading_bin(loading_bin, @invalid_attrs)
      assert loading_bin == Warehouse.get_loading_bin!(loading_bin.id)
    end

    test "delete_loading_bin/1 deletes the loading_bin" do
      loading_bin = loading_bin_fixture()
      assert {:ok, %LoadingBin{}} = Warehouse.delete_loading_bin(loading_bin)
      assert_raise Ecto.NoResultsError, fn -> Warehouse.get_loading_bin!(loading_bin.id) end
    end

    test "change_loading_bin/1 returns a loading_bin changeset" do
      loading_bin = loading_bin_fixture()
      assert %Ecto.Changeset{} = Warehouse.change_loading_bin(loading_bin)
    end
  end
end
