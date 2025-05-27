defmodule Examples.OfficeSupplyStoreTest do
  use Examples.DataCase

  alias Examples.OfficeSupplyStore

  describe "office_supply__store_people" do
    alias Examples.OfficeSupplyStore.Person

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{name: nil, born_at: nil, email: nil, telephone_number: nil}

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert OfficeSupplyStore.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{
        name: "some name",
        born_at: ~D[2025-05-26],
        email: "some email",
        telephone_number: "some telephone_number"
      }

      assert {:ok, %Person{} = person} = OfficeSupplyStore.create_person(valid_attrs)
      assert person.name == "some name"
      assert person.born_at == ~D[2025-05-26]
      assert person.email == "some email"
      assert person.telephone_number == "some telephone_number"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()

      update_attrs = %{
        name: "some updated name",
        born_at: ~D[2025-05-27],
        email: "some updated email",
        telephone_number: "some updated telephone_number"
      }

      assert {:ok, %Person{} = person} = OfficeSupplyStore.update_person(person, update_attrs)
      assert person.name == "some updated name"
      assert person.born_at == ~D[2025-05-27]
      assert person.email == "some updated email"
      assert person.telephone_number == "some updated telephone_number"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.update_person(person, @invalid_attrs)
      assert person == OfficeSupplyStore.get_person!(person.id)
    end
  end

  describe "office_supply_store_people" do
    alias Examples.OfficeSupplyStore.Organization

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{name: nil, state: nil, telephone_number: nil, government_id: nil}

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert OfficeSupplyStore.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{
        name: "some name",
        state: :active,
        telephone_number: "some telephone_number",
        government_id: "some government_id"
      }

      assert {:ok, %Organization{} = organization} =
               OfficeSupplyStore.create_organization(valid_attrs)

      assert organization.name == "some name"
      assert organization.state == :active
      assert organization.telephone_number == "some telephone_number"
      assert organization.government_id == "some government_id"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()

      update_attrs = %{
        name: "some updated name",
        state: :inactive,
        telephone_number: "some updated telephone_number",
        government_id: "some updated government_id"
      }

      assert {:ok, %Organization{} = organization} =
               OfficeSupplyStore.update_organization(organization, update_attrs)

      assert organization.name == "some updated name"
      assert organization.state == :inactive
      assert organization.telephone_number == "some updated telephone_number"
      assert organization.government_id == "some updated government_id"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.update_organization(organization, @invalid_attrs)

      assert organization == OfficeSupplyStore.get_organization!(organization.id)
    end
  end

  describe "office_supply_store_orders" do
    alias Examples.OfficeSupplyStore.Order

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{state: nil}

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OfficeSupplyStore.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{state: :payment_pending}

      assert {:ok, %Order{} = order} = OfficeSupplyStore.create_order(valid_attrs)
      assert order.state == :payment_pending
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{state: :delivery_pending}

      assert {:ok, %Order{} = order} = OfficeSupplyStore.update_order(order, update_attrs)
      assert order.state == :delivery_pending
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.update_order(order, @invalid_attrs)
      assert order == OfficeSupplyStore.get_order!(order.id)
    end
  end

  describe "office_supply_store_government_customers" do
    alias Examples.OfficeSupplyStore.GovernmentCustomer

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{registered_on: nil}

    test "get_government_customer!/1 returns the government_customer with given id" do
      government_customer = government_customer_fixture()

      assert OfficeSupplyStore.get_government_customer!(government_customer.id) ==
               government_customer
    end

    test "create_government_customer/1 with valid data creates a government_customer" do
      valid_attrs = %{registered_on: ~D[2025-05-26]}

      assert {:ok, %GovernmentCustomer{} = government_customer} =
               OfficeSupplyStore.create_government_customer(valid_attrs)

      assert government_customer.registered_on == ~D[2025-05-26]
    end

    test "create_government_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_government_customer(@invalid_attrs)
    end

    test "update_government_customer/2 with valid data updates the government_customer" do
      government_customer = government_customer_fixture()
      update_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:ok, %GovernmentCustomer{} = government_customer} =
               OfficeSupplyStore.update_government_customer(government_customer, update_attrs)

      assert government_customer.registered_on == ~D[2025-05-27]
    end

    test "update_government_customer/2 with invalid data returns error changeset" do
      government_customer = government_customer_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.update_government_customer(government_customer, @invalid_attrs)

      assert government_customer ==
               OfficeSupplyStore.get_government_customer!(government_customer.id)
    end
  end
end
