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
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        max_product_count: 42,
        mutually_exclusive: "some mutually_exclusive",
        name: unique_category_name(),
        permitted_colours: ["option1", "option2"],
        permitted_price_range: "120.5",
        state: :active
      })
      |> Examples.LuxuryCatalog.create_category()

    category
  end
end
