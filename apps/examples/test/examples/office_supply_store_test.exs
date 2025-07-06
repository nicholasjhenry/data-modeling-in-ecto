defmodule Examples.OfficeSupplyStoreTest do
  use Examples.DataCase

  alias Examples.OfficeSupplyStore

  describe "office_supply_store_branches" do
    alias Examples.OfficeSupplyStore.Branch

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{name: nil}

    test "create_branch/1 with valid data creates a branch" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Branch{} = branch} = OfficeSupplyStore.create_branch(valid_attrs)
      assert branch.name == "some name"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.create_branch(@invalid_attrs)
    end
  end

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

  describe "office_supply_store_government_customers" do
    alias Examples.OfficeSupplyStore.GovernmentCustomer

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{registered_on: nil}

    test "get_government_customer!/1 returns the government_customer with given id" do
      government_customer = government_customer_fixture()

      assert OfficeSupplyStore.get_government_customer!(government_customer.id).id ==
               government_customer.id
    end

    test "create_government_customer/1 with valid data creates a government_customer" do
      organization = organization_fixture()
      valid_attrs = %{registered_on: ~D[2025-05-26]}

      assert {:ok, %GovernmentCustomer{} = government_customer} =
               OfficeSupplyStore.create_government_customer(organization, valid_attrs)

      assert government_customer.registered_on == ~D[2025-05-26]
    end

    test "create_government_customer/1 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_government_customer(organization, @invalid_attrs)
    end

    test "create_government_customer/1 with an organization associated with a business customer returns an error" do
      organization = organization_fixture()
      _business_customer = business_customer_fixture(organization)
      valid_attrs = %{registered_on: ~D[2025-05-26]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_government_customer(organization, valid_attrs)

      assert "Business Customer is already assigned" in errors_on(changeset).business_rule
    end

    test "create_government_customer/1 with an organization without a government ID returns an error" do
      organization = organization_fixture(government_id: nil)
      valid_attrs = %{registered_on: ~D[2025-05-26]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_government_customer(organization, valid_attrs)

      assert "Government ID is required" in errors_on(changeset).business_rule
    end

    test "create_government_customer/1 with an inactive organization returns an error" do
      organization = organization_fixture(state: :inactive)

      valid_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_government_customer(organization, valid_attrs)

      assert "Organization is not active" in errors_on(changeset).business_rule
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

      assert(
        OfficeSupplyStore.government_customer_equal?(
          government_customer,
          OfficeSupplyStore.get_government_customer!(government_customer.id)
        )
      )
    end
  end

  describe "office_supply_store_business_customers" do
    alias Examples.OfficeSupplyStore.BusinessCustomer

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{registered_on: nil}

    test "get_business_customer!/1 returns the business_customer with given id" do
      business_customer = business_customer_fixture()

      assert OfficeSupplyStore.business_customer_equal?(
               OfficeSupplyStore.get_business_customer!(business_customer.id),
               business_customer
             )
    end

    test "create_business_customer/1 with valid data creates a business_customer" do
      organization = organization_fixture()
      valid_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:ok, %BusinessCustomer{} = business_customer} =
               OfficeSupplyStore.create_business_customer(organization, valid_attrs)

      assert business_customer.registered_on == ~D[2025-05-27]
    end

    test "create_business_customer/1 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_business_customer(organization, @invalid_attrs)
    end

    test "create_business_customer/1 with an organization associated with a government customer returns an error" do
      organization = organization_fixture()
      _government_customer = government_customer_fixture(organization)

      valid_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_business_customer(organization, valid_attrs)

      assert "Government customer is already assigned" in errors_on(changeset).business_rule
    end

    test "create_business_customer/1 with an organization without a contact telephone number returns an error" do
      organization = organization_fixture(telephone_number: nil)
      _government_customer = government_customer_fixture(organization)

      valid_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_business_customer(organization, valid_attrs)

      assert "Telephone number is required" in errors_on(changeset).business_rule
    end

    test "create_business_customer/1 with an inactive organization returns an error" do
      organization = organization_fixture(state: :inactive)

      valid_attrs = %{registered_on: ~D[2025-05-27]}

      assert {:error, changeset} =
               OfficeSupplyStore.create_business_customer(organization, valid_attrs)

      assert "Organization is not active" in errors_on(changeset).business_rule
    end

    test "update_business_customer/2 with valid data updates the business_customer" do
      business_customer = business_customer_fixture()
      update_attrs = %{registered_on: ~D[2025-05-28]}

      assert {:ok, %BusinessCustomer{} = business_customer} =
               OfficeSupplyStore.update_business_customer(business_customer, update_attrs)

      assert business_customer.registered_on == ~D[2025-05-28]
    end

    test "update_business_customer/2 with invalid data returns error changeset" do
      business_customer = business_customer_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.update_business_customer(business_customer, @invalid_attrs)

      assert OfficeSupplyStore.business_customer_equal?(
               business_customer,
               OfficeSupplyStore.get_business_customer!(business_customer.id)
             )
    end
  end

  describe "office_supply_store_products" do
    alias Examples.OfficeSupplyStore.Product

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{name: nil, price: nil}

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert OfficeSupplyStore.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{name: "some name", price: "120.5"}

      assert {:ok, %Product{} = product} = OfficeSupplyStore.create_product(valid_attrs)
      assert product.name == "some name"
      assert product.price == Decimal.new("120.5")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OfficeSupplyStore.create_product(@invalid_attrs)
    end
  end

  describe "office_supply_store_orders" do
    alias Examples.OfficeSupplyStore.Order

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{state: nil, shipping_address: nil}

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert OfficeSupplyStore.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture()
      _stock_entry = stock_entry_fixture(branch, product)
      valid_attrs = %{state: :payment_pending, shipping_address: "some shipping address"}
      line_item_attrs = %{price: "120.5", quantity: 42, shipping_address: "some shipping address"}

      assert {:ok, %Order{} = order} =
               OfficeSupplyStore.create_order(
                 customer,
                 branch,
                 product,
                 valid_attrs,
                 line_item_attrs
               )

      assert Enum.count(order.line_items) == 1
      assert order.state == :payment_pending
    end

    test "create_order/1 with invalid data returns error changeset" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture()
      line_item_attrs = %{quantity: 42, price: "120.5"}

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_order(
                 customer,
                 branch,
                 product,
                 @invalid_attrs,
                 line_item_attrs
               )
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

  describe "office_supply_store_order_line_items" do
    alias Examples.OfficeSupplyStore.Order

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{price: nil, quantity: nil}

    test "create_order_line_item/1 with valid data creates a order_line_item" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture()
      _stock_entry = stock_entry_fixture(branch, product)
      order = order_fixture(customer, branch)

      valid_attrs = %{price: "120.5", quantity: 42}

      assert {:ok, %Order{} = order} =
               OfficeSupplyStore.create_order_line_item(order, product, valid_attrs)

      assert [order_line_item, _another_line_item] = order.line_items
      assert order_line_item.price == Decimal.new("120.5")
      assert order_line_item.quantity == 42
    end

    test "create_order_line_item/1 with invalid data returns error changeset" do
      order = order_fixture()
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_order_line_item(order, product, @invalid_attrs)
    end

    test "delete_order_line_item/1 with order in a valid state deletes a order_line_item" do
      order = order_fixture()
      [order_line_item] = order.line_items

      assert {:error, changeset} =
               OfficeSupplyStore.delete_order_line_item(order, order_line_item)

      assert "An order requires at least one line item" in errors_on(changeset).business_rule
    end
  end

  describe "adding a product to an order" do
    alias Examples.OfficeSupplyStore.Order

    import Examples.OfficeSupplyStoreFixtures

    test "validate permitted product order type" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture(permitted_order_type: :pickup)
      order = order_fixture(customer, branch, product, type: :pickup)

      valid_attrs = %{price: "120.5", quantity: 42}

      another_product = product_fixture(permitted_order_type: :delivery)
      # _stock_entry = stock_entry_fixture(branch, another_product)

      assert {:error, changeset} =
               OfficeSupplyStore.add_product_to_order(order, another_product, valid_attrs)

      assert "Product cannot be added to this order type" in errors_on(changeset).business_rule
    end

    test "validate product is stocked by branch" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture()
      _stock_entry = stock_entry_fixture(branch, product)
      order = order_fixture(customer, branch)

      valid_attrs = %{price: "120.5", quantity: 42}

      assert {:ok, _order} =
               OfficeSupplyStore.add_product_to_order(order, product, valid_attrs)

      another_product = product_fixture()

      assert {:error, changeset} =
               OfficeSupplyStore.add_product_to_order(order, another_product, valid_attrs)

      assert "Product is not stocked by branch" in errors_on(changeset).business_rule
    end

    test "validate customer status for product type" do
      organization = organization_fixture()
      customer = business_customer_fixture(organization, status: :standard)
      branch = branch_fixture()

      standard_product = product_fixture()
      specialty_product = product_fixture(type: :speciality)
      _stock_entry = stock_entry_fixture(branch, standard_product)
      _stock_entry = stock_entry_fixture(branch, specialty_product)

      order = order_fixture(customer, branch)

      valid_attrs = %{price: "120.5", quantity: 42}

      assert {:ok, _order} =
               OfficeSupplyStore.add_product_to_order(order, standard_product, valid_attrs)

      assert {:error, changeset} =
               OfficeSupplyStore.add_product_to_order(order, specialty_product, valid_attrs)

      assert "Product is not permitted for customer" in errors_on(changeset).business_rule
    end
  end

  describe "office_supply_store_stock_entries" do
    alias Examples.OfficeSupplyStore.StockEntry

    import Examples.OfficeSupplyStoreFixtures

    test "get_stock_entry!/1 returns the stock_entry with given id" do
      stock_entry = stock_entry_fixture()
      assert OfficeSupplyStore.get_stock_entry!(stock_entry.id) == stock_entry
    end

    test "create_stock_entry/1 with valid data creates a stock_entry" do
      product = product_fixture()
      branch = branch_fixture()

      assert {:ok, %StockEntry{} = _stock_entry} =
               OfficeSupplyStore.create_stock_entry(branch, product)
    end
  end

  describe "office_supply_deliveries" do
    alias Examples.OfficeSupplyStore.Delivery

    import Examples.OfficeSupplyStoreFixtures

    @invalid_attrs %{type: nil, state: nil, address: nil}

    test "get_delivery!/1 returns the delivery with given id" do
      delivery = delivery_fixture()
      assert OfficeSupplyStore.get_delivery!(delivery.id).id == delivery.id
    end

    test "create_delivery/1 with valid data creates a delivery" do
      order = completed_order_fixture()
      valid_attrs = %{type: :partial, state: :pending, address: "some address"}

      assert {:ok, %Delivery{} = delivery} = OfficeSupplyStore.create_delivery(order, valid_attrs)
      assert delivery.type == :partial
      assert delivery.state == :pending
      assert delivery.address == "some address"
      assert delivery.order_id == order.id
    end

    test "create_delivery/1 with invalid data returns error changeset" do
      order = order_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OfficeSupplyStore.create_delivery(order, @invalid_attrs)
    end
  end

  describe "delivering an order" do
    alias Examples.OfficeSupplyStore.Delivery

    import Examples.OfficeSupplyStoreFixtures

    test "validates delivery address with order shipping address" do
      order = order_fixture()
      valid_attrs = %{type: :partial, state: :pending, address: "some invalid address"}

      assert {:error, changeset} = OfficeSupplyStore.create_delivery(order, valid_attrs)

      assert "Delivery address must the the same as order shipping address" in errors_on(
               changeset
             ).business_rule
    end

    test "validates order state" do
      customer = business_customer_fixture()
      branch = branch_fixture()
      product = product_fixture()
      valid_attrs = %{type: :partial, state: :pending, address: "some address"}

      valid_order = order_fixture(customer, branch, product, state: :completed)
      assert {:ok, _delivery} = OfficeSupplyStore.create_delivery(valid_order, valid_attrs)

      another_product = product_fixture()
      invalid_order = order_fixture(customer, branch, another_product, state: :payment_pending)
      assert {:error, changeset} = OfficeSupplyStore.create_delivery(invalid_order, valid_attrs)

      assert "An order must be completed to be delivered" in errors_on(changeset).business_rule
    end
  end
end
