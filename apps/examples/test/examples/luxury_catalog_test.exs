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
end
