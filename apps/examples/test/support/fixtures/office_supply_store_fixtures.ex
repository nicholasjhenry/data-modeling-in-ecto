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
  def order_fixture(
        customer \\ business_customer_fixture(),
        branch \\ branch_fixture(),
        product \\ product_fixture(),
        attrs \\ %{}
      ) do
    attrs =
      Enum.into(attrs, %{state: :payment_pending, shipping_address: "some address"})

    _stock_entry = stock_entry_fixture(branch, product)

    {:ok, order} =
      Examples.OfficeSupplyStore.create_order(customer, branch, product, attrs, %{
        price: "120.5",
        quantity: 42
      })

    order
  end

  def completed_order_fixture(
        customer \\ business_customer_fixture(),
        branch \\ branch_fixture(),
        product \\ product_fixture(),
        attrs \\ %{}
      ) do
    attrs = Enum.into(attrs, %{state: :completed})
    order_fixture(customer, branch, product, attrs)
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

  @doc """
  Generate a branch.
  """
  def branch_fixture(attrs \\ %{}) do
    {:ok, branch} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Examples.OfficeSupplyStore.create_branch()

    branch
  end

  @doc """
  Generate a stock_entry.
  """
  def stock_entry_fixture(branch \\ branch_fixture(), product \\ product_fixture()) do
    {:ok, stock_entry} = Examples.OfficeSupplyStore.create_stock_entry(branch, product)

    stock_entry
  end

  @doc """
  Generate a delivery.
  """
  def delivery_fixture(order \\ completed_order_fixture(), attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        address: order.shipping_address,
        state: :pending,
        type: :partial
      })

    {:ok, delivery} = Examples.OfficeSupplyStore.create_delivery(order, attrs)

    delivery
  end
end
