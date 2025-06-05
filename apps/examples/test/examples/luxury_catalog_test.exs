defmodule Examples.LuxuryCatalogTest do
  use Examples.DataCase

  alias Examples.LuxuryCatalog

  describe "luxury_catalog_categories" do
    alias Examples.LuxuryCatalog.Category

    import Examples.LuxuryCatalogFixtures

    @invalid_attrs %{
      name: nil,
      code: nil
    }

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert LuxuryCatalog.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{
        name: "some name",
        code: "some code",
        max_product_count: 42,
        permitted_colours: ["blue", "green"],
        permitted_price_range: NumRange.new(Decimal.new(2000), Decimal.new(3000)),
        mutually_exclusive: true
      }

      assert {:ok, %Category{} = category} = LuxuryCatalog.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.code == "some code"
      assert category.state == :active
      assert category.max_product_count == 42
      assert category.permitted_colours == ["blue", "green"]
      assert Decimal.equal?(category.permitted_price_range.lower, Decimal.new(2000))
      assert Decimal.equal?(category.permitted_price_range.upper, Decimal.new(3000))
      assert category.mutually_exclusive == true
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.create_category(@invalid_attrs)
    end
  end

  describe "luxury_catalog_products" do
    alias Examples.LuxuryCatalog.Product

    import Examples.LuxuryCatalogFixtures

    @invalid_attrs %{
      name: nil,
      color: nil,
      permitted_category_codes: nil,
      max_category_count: nil,
      max_category_member_count: nil,
      price: nil
    }

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert LuxuryCatalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        name: "some name",
        color: "black",
        permitted_category_codes: ["option1", "option2"],
        max_category_count: 42,
        max_category_member_count: 42,
        price: "120.5"
      }

      assert {:ok, %Product{} = product} = LuxuryCatalog.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.state == :active
      assert product.color == :black
      assert product.permitted_category_codes == ["option1", "option2"]
      assert product.max_category_count == 42
      assert product.max_category_member_count == 42
      assert product.price == Decimal.new("120.5")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LuxuryCatalog.create_product(@invalid_attrs)
    end
  end

  describe "luxury_catalog_categories and luxury_catalog_products" do
    alias Examples.LuxuryCatalog.Category

    import Examples.LuxuryCatalogFixtures

    test "add product to category" do
      category = category_fixture()
      product = product_fixture()

      assert {:ok, category} = LuxuryCatalog.add_product_to_category(category, product)

      assert List.first(category.products).id == product.id
    end

    test "validate permitted categories" do
      permitted_category = category_fixture(code: "permitted_category")
      not_permitted_category = category_fixture(code: "not_permitted_category")
      product = product_fixture(permitted_category_codes: [permitted_category.code])

      assert {:ok, _category} = LuxuryCatalog.add_product_to_category(permitted_category, product)

      assert {:error, changeset} =
               LuxuryCatalog.add_product_to_category(not_permitted_category, product)

      assert "Product is not permitted to be added to this category" in errors_on(changeset).business_rule
    end
  end
end
