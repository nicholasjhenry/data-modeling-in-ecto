defmodule Examples.WarehouseTest do
  use Examples.DataCase

  alias Examples.Warehouse

  describe "warehouse_loading_areas" do
    alias Examples.Warehouse.LoadingArea

    import Examples.WarehouseFixtures

    @invalid_attrs %{size: nil, type: nil, state: nil, average_temperature: nil}

    test "list_warehouse_loading_areas/0 returns all warehouse_loading_areas" do
      loading_area = loading_area_fixture()
      assert Warehouse.list_warehouse_loading_areas() == [loading_area]
    end

    test "get_loading_area!/1 returns the loading_area with given id" do
      loading_area = loading_area_fixture()
      assert Warehouse.get_loading_area!(loading_area.id) == loading_area
    end

    test "create_loading_area/1 with valid data creates a loading_area" do
      valid_attrs = %{size: "120.5", type: :room_temperature, state: :static, average_temperature: "120.5"}

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
      update_attrs = %{size: "456.7", type: :refrigerated, state: :receiving, average_temperature: "456.7"}

      assert {:ok, %LoadingArea{} = loading_area} = Warehouse.update_loading_area(loading_area, update_attrs)
      assert loading_area.size == Decimal.new("456.7")
      assert loading_area.type == :refrigerated
      assert loading_area.state == :receiving
      assert loading_area.average_temperature == Decimal.new("456.7")
    end

    test "update_loading_area/2 with invalid data returns error changeset" do
      loading_area = loading_area_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehouse.update_loading_area(loading_area, @invalid_attrs)
      assert loading_area == Warehouse.get_loading_area!(loading_area.id)
    end

    test "delete_loading_area/1 deletes the loading_area" do
      loading_area = loading_area_fixture()
      assert {:ok, %LoadingArea{}} = Warehouse.delete_loading_area(loading_area)
      assert_raise Ecto.NoResultsError, fn -> Warehouse.get_loading_area!(loading_area.id) end
    end

    test "change_loading_area/1 returns a loading_area changeset" do
      loading_area = loading_area_fixture()
      assert %Ecto.Changeset{} = Warehouse.change_loading_area(loading_area)
    end
  end
end
