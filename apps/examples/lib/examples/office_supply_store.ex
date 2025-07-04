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
    |> Repo.preload(branch: [], line_items: :product)
  end

  def create_order(branch, product, attrs, line_item_attrs) do
    %Order{}
    |> Repo.preload(:line_items)
    |> Order.changeset(attrs)
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
    |> Repo.preload(:line_items)
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

  @doc """
  Returns the list of office_supply_store_stock_entries.

  ## Examples

      iex> list_office_supply_store_stock_entries()
      [%StockEntry{}, ...]

  """
  def list_office_supply_store_stock_entries do
    Repo.all(StockEntry)
  end

  @doc """
  Gets a single stock_entry.

  Raises `Ecto.NoResultsError` if the Stock entry does not exist.

  ## Examples

      iex> get_stock_entry!(123)
      %StockEntry{}

      iex> get_stock_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock_entry!(id), do: Repo.get!(StockEntry, id)

  @doc """
  Creates a stock_entry.

  ## Examples

      iex> create_stock_entry(%{field: value})
      {:ok, %StockEntry{}}

      iex> create_stock_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock_entry(attrs \\ %{}) do
    %StockEntry{}
    |> StockEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock_entry.

  ## Examples

      iex> update_stock_entry(stock_entry, %{field: new_value})
      {:ok, %StockEntry{}}

      iex> update_stock_entry(stock_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock_entry(%StockEntry{} = stock_entry, attrs) do
    stock_entry
    |> StockEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock_entry.

  ## Examples

      iex> delete_stock_entry(stock_entry)
      {:ok, %StockEntry{}}

      iex> delete_stock_entry(stock_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock_entry(%StockEntry{} = stock_entry) do
    Repo.delete(stock_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock_entry changes.

  ## Examples

      iex> change_stock_entry(stock_entry)
      %Ecto.Changeset{data: %StockEntry{}}

  """
  def change_stock_entry(%StockEntry{} = stock_entry, attrs \\ %{}) do
    StockEntry.changeset(stock_entry, attrs)
  end
end
