defmodule Examples.LuxuryCatalog do
  @moduledoc """
  The LuxuryCatalog context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.LuxuryCatalog.Category

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def discontinue_category(category) do
    category
    |> Category.discontinue_changeset()
    |> Repo.update()
  end

  alias Examples.LuxuryCatalog.Product

  def get_product!(id), do: Repo.get!(Product, id)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def add_product_to_category(category, product) do
    product =
      product
      |> Repo.preload(:categories)
      |> Product.calculate_category_count()

    category
    |> Repo.preload([:products])
    |> Category.calculate_product_count()
    |> Category.put_product_changeset(product)
    |> Repo.update()
  end

  def discontinue_product(product) do
    product
    |> Product.discontinue_changeset()
    |> Repo.update()
  end
end
