defmodule Examples.OfficeSupplyStoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Examples.OfficeSupplyStore` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        born_at: ~D[2025-05-26],
        email: "some email",
        name: "some name",
        telephone_number: "some telephone_number"
      })
      |> Examples.OfficeSupplyStore.create_person()

    person
  end

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        government_id: "some government_id",
        name: "some name",
        state: :active,
        telephone_number: "some telephone_number"
      })
      |> Examples.OfficeSupplyStore.create_organization()

    organization
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    product = product_fixture()

    {:ok, order} =
      attrs
      |> Enum.into(%{
        state: :payment_pending
      })
      |> Examples.OfficeSupplyStore.create_order(product, %{price: "120.5", quantity: 42})

    order
  end

  @doc """
  Generate a government_customer.
  """
  def government_customer_fixture(organization \\ organization_fixture(), attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        registered_on: ~D[2025-05-26]
      })

    {:ok, government_customer} =
      Examples.OfficeSupplyStore.create_government_customer(organization, attrs)

    government_customer
  end

  @doc """
  Generate a business_customer.
  """
  def business_customer_fixture(organization \\ organization_fixture(), attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        registered_on: ~D[2025-05-27]
      })

    {:ok, business_customer} =
      Examples.OfficeSupplyStore.create_business_customer(organization, attrs)

    business_customer
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: "120.5"
      })
      |> Examples.OfficeSupplyStore.create_product()

    product
  end
end
