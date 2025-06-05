defmodule Examples.LuxuryCatalogTest do
  use Examples.DataCase

  alias Examples.LuxuryCatalog

  describe "luxury_catalog_categories" do
    alias Examples.LuxuryCatalog.Category

    import Examples.LuxuryCatalogFixtures

    @invalid_attrs %{name: nil, state: nil, max_product_count: nil, permitted_colours: nil, permitted_price_range: nil, mutually_exclusive: nil}

    test "list_luxury_catalog_categories/0 returns all luxury_catalog_categories" do
      category = category_fixture()
      assert LuxuryCatalog.list_luxury_catalog_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert LuxuryCatalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name", state: :active, max_product_count: 42, permitted_colours: ["option1", "option2"], permitted_price_range: "120.5", mutually_exclusive: "some mutually_exclusive"}

      assert {:ok, %Category{} = category} = LuxuryCatalog.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.state == :active
      assert category.max_product_count == 42
      assert category.permitted_colours == ["option1", "option2"]
      assert category.permitted_price_range == Decimal.new("120.5")
      assert category.mutually_exclusive == "some mutually_exclusive"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name", state: :discountinued, max_product_count: 43, permitted_colours: ["option1"], permitted_price_range: "456.7", mutually_exclusive: "some updated mutually_exclusive"}

      assert {:ok, %Category{} = category} = LuxuryCatalog.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.state == :discountinued
      assert category.max_product_count == 43
      assert category.permitted_colours == ["option1"]
      assert category.permitted_price_range == Decimal.new("456.7")
      assert category.mutually_exclusive == "some updated mutually_exclusive"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.update_category(category, @invalid_attrs)
      assert category == LuxuryCatalog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = LuxuryCatalog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> LuxuryCatalog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = LuxuryCatalog.change_category(category)
    end
  end
end
