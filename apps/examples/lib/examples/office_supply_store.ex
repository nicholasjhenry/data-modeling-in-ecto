defmodule Examples.OfficeSupplyStore do
  @moduledoc """
  The OfficeSupplyStore context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

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

  alias Examples.OfficeSupplyStore.Order

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  alias Examples.OfficeSupplyStore.GovernmentCustomer

  def get_government_customer!(id), do: Repo.get!(GovernmentCustomer, id)

  def create_government_customer(organization, attrs \\ %{}) do
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

  @doc """
  Returns the list of office_supply_store_business_customers.

  ## Examples

      iex> list_office_supply_store_business_customers()
      [%BusinessCustomer{}, ...]

  """
  def list_office_supply_store_business_customers do
    Repo.all(BusinessCustomer)
  end

  @doc """
  Gets a single business_customer.

  Raises `Ecto.NoResultsError` if the Business customer does not exist.

  ## Examples

      iex> get_business_customer!(123)
      %BusinessCustomer{}

      iex> get_business_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business_customer!(id), do: Repo.get!(BusinessCustomer, id)

  @doc """
  Creates a business_customer.

  ## Examples

      iex> create_business_customer(%{field: value})
      {:ok, %BusinessCustomer{}}

      iex> create_business_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_business_customer(attrs \\ %{}) do
    %BusinessCustomer{}
    |> BusinessCustomer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a business_customer.

  ## Examples

      iex> update_business_customer(business_customer, %{field: new_value})
      {:ok, %BusinessCustomer{}}

      iex> update_business_customer(business_customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business_customer(%BusinessCustomer{} = business_customer, attrs) do
    business_customer
    |> BusinessCustomer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a business_customer.

  ## Examples

      iex> delete_business_customer(business_customer)
      {:ok, %BusinessCustomer{}}

      iex> delete_business_customer(business_customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business_customer(%BusinessCustomer{} = business_customer) do
    Repo.delete(business_customer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_customer changes.

  ## Examples

      iex> change_business_customer(business_customer)
      %Ecto.Changeset{data: %BusinessCustomer{}}

  """
  def change_business_customer(%BusinessCustomer{} = business_customer, attrs \\ %{}) do
    BusinessCustomer.changeset(business_customer, attrs)
  end
end
