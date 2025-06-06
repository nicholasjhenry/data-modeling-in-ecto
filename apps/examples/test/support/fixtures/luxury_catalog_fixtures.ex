defmodule Examples.LuxuryCatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.LuxuryCatalog` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique category code.
  """
  def unique_category_code, do: "some code#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: unique_category_name(),
        code: unique_category_code()
      })
      |> Examples.LuxuryCatalog.create_category()

    category
  end

  @doc """
  Generate a unique product name.
  """
  def unique_product_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        color: "black",
        max_category_member_count: 42,
        name: unique_product_name(),
        price: "120",
        state: :active
      })
      |> Examples.LuxuryCatalog.create_product()

    product
  end
end
