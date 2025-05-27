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

  @doc """
  Returns the list of office_supply_store_government_customers.

  ## Examples

      iex> list_office_supply_store_government_customers()
      [%GovernmentCustomer{}, ...]

  """
  def list_office_supply_store_government_customers do
    Repo.all(GovernmentCustomer)
  end

  @doc """
  Gets a single government_customer.

  Raises `Ecto.NoResultsError` if the Government customer does not exist.

  ## Examples

      iex> get_government_customer!(123)
      %GovernmentCustomer{}

      iex> get_government_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_government_customer!(id), do: Repo.get!(GovernmentCustomer, id)

  @doc """
  Creates a government_customer.

  ## Examples

      iex> create_government_customer(%{field: value})
      {:ok, %GovernmentCustomer{}}

      iex> create_government_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_government_customer(attrs \\ %{}) do
    %GovernmentCustomer{}
    |> GovernmentCustomer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a government_customer.

  ## Examples

      iex> update_government_customer(government_customer, %{field: new_value})
      {:ok, %GovernmentCustomer{}}

      iex> update_government_customer(government_customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_government_customer(%GovernmentCustomer{} = government_customer, attrs) do
    government_customer
    |> GovernmentCustomer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a government_customer.

  ## Examples

      iex> delete_government_customer(government_customer)
      {:ok, %GovernmentCustomer{}}

      iex> delete_government_customer(government_customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_government_customer(%GovernmentCustomer{} = government_customer) do
    Repo.delete(government_customer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking government_customer changes.

  ## Examples

      iex> change_government_customer(government_customer)
      %Ecto.Changeset{data: %GovernmentCustomer{}}

  """
  def change_government_customer(%GovernmentCustomer{} = government_customer, attrs \\ %{}) do
    GovernmentCustomer.changeset(government_customer, attrs)
  end
end
