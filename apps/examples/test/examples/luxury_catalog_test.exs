defmodule Examples.LuxuryCatalogTest do
  use Examples.DataCase

  alias Examples.LuxuryCatalog

  describe "luxury_catalog_categories" do
    alias Examples.LuxuryCatalog.Category

    import Examples.LuxuryCatalogFixtures

    @invalid_attrs %{
      name: nil,
      state: nil,
      max_product_count: nil,
      permitted_colours: nil,
      permitted_price_range: nil,
      mutually_exclusive: nil
    }

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert LuxuryCatalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{
        name: "some name",
        state: :active,
        max_product_count: 42,
        permitted_colours: ["option1", "option2"],
        permitted_price_range: "120.5",
        mutually_exclusive: "some mutually_exclusive"
      }

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
  end

  describe "luxury_catalog_products" do
    alias Examples.LuxuryCatalog.Product

    import Examples.LuxuryCatalogFixtures

    @invalid_attrs %{name: nil, state: nil, color: nil, permitted_category_codes: nil, max_category_count: nil, max_category_member_count: nil, price: nil}

    test "list_luxury_catalog_products/0 returns all luxury_catalog_products" do
      product = product_fixture()
      assert LuxuryCatalog.list_luxury_catalog_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert LuxuryCatalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", state: :active, color: "some color", permitted_category_codes: ["option1", "option2"], max_category_count: 42, max_category_member_count: 42, price: "120.5"}

      assert {:ok, %Product{} = product} = LuxuryCatalog.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.state == :active
      assert product.color == "some color"
      assert product.permitted_category_codes == ["option1", "option2"]
      assert product.max_category_count == 42
      assert product.max_category_member_count == 42
      assert product.price == Decimal.new("120.5")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name", state: :discontinued, color: "some updated color", permitted_category_codes: ["option1"], max_category_count: 43, max_category_member_count: 43, price: "456.7"}

      assert {:ok, %Product{} = product} = LuxuryCatalog.update_product(product, update_attrs)
      assert product.name == "some updated name"
      assert product.state == :discontinued
      assert product.color == "some updated color"
      assert product.permitted_category_codes == ["option1"]
      assert product.max_category_count == 43
      assert product.max_category_member_count == 43
      assert product.price == Decimal.new("456.7")
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.update_product(product, @invalid_attrs)
      assert product == LuxuryCatalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = LuxuryCatalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> LuxuryCatalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = LuxuryCatalog.change_product(product)
    end
  end
end
