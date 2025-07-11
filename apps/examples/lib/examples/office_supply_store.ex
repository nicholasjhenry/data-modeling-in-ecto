defmodule Examples.OfficeSupplyStore do
  @moduledoc """
  The OfficeSupplyStore context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.OfficeSupplyStore.Branch

  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.OfficeSupplyStore.Person

  def get_person!(id), do: Repo.get!(Person, id)

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  alias Examples.OfficeSupplyStore.Organization

  def get_organization!(id), do: Repo.get!(Organization, id)

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  alias Examples.OfficeSupplyStore.GovernmentCustomer

  def get_government_customer!(id), do: Repo.get!(GovernmentCustomer, id)

  def create_government_customer(organization, attrs \\ %{}) do
    organization = Repo.preload(organization, :business_customer)

    %GovernmentCustomer{}
    |> GovernmentCustomer.changeset(attrs)
    |> GovernmentCustomer.put_organization_changeset(organization)
    |> Repo.insert()
  end

  def update_government_customer(%GovernmentCustomer{} = government_customer, attrs) do
    government_customer
    |> GovernmentCustomer.changeset(attrs)
    |> Repo.update()
  end

  def government_customer_equal?(
        %GovernmentCustomer{} = government_customer,
        %GovernmentCustomer{} = other
      ) do
    government_customer.id == other.id &&
      Date.compare(government_customer.registered_on, other.registered_on) == :eq
  end

  alias Examples.OfficeSupplyStore.BusinessCustomer

  def get_business_customer!(id), do: Repo.get!(BusinessCustomer, id)

  def create_business_customer(organization, attrs \\ %{}) do
    organization = Repo.preload(organization, :government_customer)

    %BusinessCustomer{}
    |> BusinessCustomer.changeset(attrs)
    |> BusinessCustomer.put_organization_changeset(organization)
    |> Repo.insert()
  end

  def update_business_customer(%BusinessCustomer{} = business_customer, attrs) do
    business_customer
    |> BusinessCustomer.changeset(attrs)
    |> Repo.update()
  end

  def business_customer_equal?(
        %BusinessCustomer{} = business_customer,
        %BusinessCustomer{} = other
      ) do
    business_customer.id == other.id &&
      Date.compare(business_customer.registered_on, other.registered_on) == :eq
  end

  alias Examples.OfficeSupplyStore.Product

  def get_product!(id), do: Repo.get!(Product, id)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  alias Examples.OfficeSupplyStore.Order

  def get_order!(id) do
    Order
    |> Repo.get!(id)
    |> Repo.preload(
      customer: [organization: :government_customer],
      branch: :stock_entries,
      line_items: :product
    )
  end

  def create_order(customer, branch, product, attrs, line_item_attrs) do
    branch = Repo.preload(branch, :stock_entries)

    %Order{}
    |> Repo.preload(:line_items)
    |> Order.changeset(attrs)
    |> Order.put_customer_changeset(customer)
    |> Order.put_branch_changeset(branch)
    |> Order.put_line_item_changeset(product, line_item_attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def add_product_to_order(order, product, attrs \\ %{}),
    do: create_order_line_item(order, product, attrs)

  def create_order_line_item(order, product, attrs \\ %{}) do
    order
    |> Repo.preload([:line_items, branch: :stock_entries])
    |> Order.put_line_item_changeset(product, attrs)
    |> Repo.update()
  end

  def delete_order_line_item(order, order_line_item) do
    order
    |> Repo.preload(:line_items)
    |> Order.delete_line_item_changeset(order_line_item)
    |> Repo.update()
  end

  alias Examples.OfficeSupplyStore.StockEntry

  def get_stock_entry!(id) do
    StockEntry
    |> Repo.get!(id)
    |> Repo.preload([:branch, :product])
  end

  def create_stock_entry(branch, product) do
    %StockEntry{}
    |> StockEntry.put_branch_changeset(branch)
    |> StockEntry.put_product_changeset(product)
    |> Repo.insert()
  end

  alias Examples.OfficeSupplyStore.Delivery

  def get_delivery!(id), do: Repo.get!(Delivery, id)

  def create_delivery(order, attrs \\ %{}) do
    %Delivery{}
    |> Delivery.changeset(attrs)
    |> Delivery.put_order_changeset(order)
    |> Repo.insert()
  end

  alias Examples.OfficeSupplyStore.DeliveryLineItem

  @doc """
  Returns the list of office_supply_store_delivery_line_items.

  ## Examples

      iex> list_office_supply_store_delivery_line_items()
      [%DeliveryLineItem{}, ...]

  """
  def list_office_supply_store_delivery_line_items do
    Repo.all(DeliveryLineItem)
  end

  @doc """
  Gets a single delivery_line_item.

  Raises `Ecto.NoResultsError` if the Delivery line item does not exist.

  ## Examples

      iex> get_delivery_line_item!(123)
      %DeliveryLineItem{}

      iex> get_delivery_line_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_delivery_line_item!(id), do: Repo.get!(DeliveryLineItem, id)

  @doc """
  Creates a delivery_line_item.

  ## Examples

      iex> create_delivery_line_item(%{field: value})
      {:ok, %DeliveryLineItem{}}

      iex> create_delivery_line_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_delivery_line_item(attrs \\ %{}) do
    %DeliveryLineItem{}
    |> DeliveryLineItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a delivery_line_item.

  ## Examples

      iex> update_delivery_line_item(delivery_line_item, %{field: new_value})
      {:ok, %DeliveryLineItem{}}

      iex> update_delivery_line_item(delivery_line_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_delivery_line_item(%DeliveryLineItem{} = delivery_line_item, attrs) do
    delivery_line_item
    |> DeliveryLineItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a delivery_line_item.

  ## Examples

      iex> delete_delivery_line_item(delivery_line_item)
      {:ok, %DeliveryLineItem{}}

      iex> delete_delivery_line_item(delivery_line_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_delivery_line_item(%DeliveryLineItem{} = delivery_line_item) do
    Repo.delete(delivery_line_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery_line_item changes.

  ## Examples

      iex> change_delivery_line_item(delivery_line_item)
      %Ecto.Changeset{data: %DeliveryLineItem{}}

  """
  def change_delivery_line_item(%DeliveryLineItem{} = delivery_line_item, attrs \\ %{}) do
    DeliveryLineItem.changeset(delivery_line_item, attrs)
  end
end
