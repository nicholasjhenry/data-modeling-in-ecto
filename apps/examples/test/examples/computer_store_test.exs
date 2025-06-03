defmodule Examples.ComputerStoreTest do
  use Examples.DataCase

  alias Examples.ComputerStore

  describe "computer_store_systems" do
    alias Examples.ComputerStore.System

    import Examples.ComputerStoreFixtures

    @invalid_attrs %{
      type: nil,
      price: nil,
      weight: nil,
      electrical_requirements: nil,
      approval_state: nil
    }

    test "get_system!/1 returns the system with given id" do
      system = system_fixture()
      assert ComputerStore.get_system!(system.id) == system
    end

    test "create_system/1 with valid data creates a system" do
      component = component_fixture()

      valid_attrs = %{
        type: :server,
        price: "120.5",
        weight: "120.5",
        electrical_requirements: :domestic,
        approval_state: :pending
      }

      assert {:ok, %System{} = system} = ComputerStore.create_system(component, valid_attrs)
      assert system.type == :server
      assert system.price == Decimal.new("120.5")
      assert system.weight == Decimal.new("120.5")
      assert system.electrical_requirements == :domestic
      assert system.approval_state == :pending
    end

    test "create_system/1 with invalid data returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = ComputerStore.create_system(component, @invalid_attrs)
    end

    test "update_system/2 with valid data updates the system" do
      system = system_fixture()

      update_attrs = %{
        type: :workstation,
        price: "456.7",
        weight: "456.7",
        electrical_requirements: :overseas,
        approval_state: :in_progress
      }

      assert {:ok, %System{} = system} = ComputerStore.update_system(system, update_attrs)
      assert system.type == :workstation
      assert system.price == Decimal.new("456.7")
      assert system.weight == Decimal.new("456.7")
      assert system.electrical_requirements == :overseas
      assert system.approval_state == :in_progress
    end

    test "update_system/2 with invalid data returns error changeset" do
      system = system_fixture()
      assert {:error, %Ecto.Changeset{}} = ComputerStore.update_system(system, @invalid_attrs)
      assert system == ComputerStore.get_system!(system.id)
    end
  end

  describe "computer_store_components" do
    alias Examples.ComputerStore.Component

    import Examples.ComputerStoreFixtures

    @invalid_attrs %{
      approval_state: nil,
      electrical_requirements: nil,
      price: nil,
      weight: nil,
      system_type: nil
    }

    test "get_component!/1 returns the component with given id" do
      component = component_fixture()
      assert ComputerStore.get_component!(component.id) == component
    end

    test "create_component/1 with valid data creates a component" do
      valid_attrs = %{
        approval_state: :operational,
        electrical_requirements: :domestic,
        price: "120.5",
        weight: "120.5",
        system_type: :server
      }

      assert {:ok, %Component{} = component} = ComputerStore.create_component(valid_attrs)
      assert component.approval_state == :operational
      assert component.electrical_requirements == :domestic
      assert component.price == Decimal.new("120.5")
      assert component.weight == Decimal.new("120.5")
      assert component.system_type == :server
    end

    test "create_component/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ComputerStore.create_component(@invalid_attrs)
    end

    test "update_component/2 with valid data updates the component" do
      component = component_fixture()

      update_attrs = %{
        approval_state: :damaged,
        electrical_requirements: :overseas,
        price: "456.7",
        weight: "456.7",
        system_type: :workstation
      }

      assert {:ok, %Component{} = component} =
               ComputerStore.update_component(component, update_attrs)

      assert component.approval_state == :damaged
      assert component.electrical_requirements == :overseas
      assert component.price == Decimal.new("456.7")
      assert component.weight == Decimal.new("456.7")
      assert component.system_type == :workstation
    end

    test "update_component/2 with invalid data returns error changeset" do
      component = component_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ComputerStore.update_component(component, @invalid_attrs)

      assert component == ComputerStore.get_component!(component.id)
    end
  end

  describe "computer_store_systems and computer_store_components" do
    import Examples.ComputerStoreFixtures

    test "a system has at least one component" do
      component = component_fixture()

      valid_attrs = %{
        type: :server,
        price: "120.5",
        weight: "120.5",
        electrical_requirements: :domestic,
        approval_state: :pending
      }

      assert {:ok, system} = ComputerStore.create_system(component, valid_attrs)

      assert {:error, changeset} = ComputerStore.remove_component_from_system(system, component)
      assert "System must have at least one component" in errors_on(changeset).business_rule
    end

    test "a component can be part of at most one system; however, if removed from a system, it can be added to another system later, or it can be sold individually." do
      component = component_fixture()
      system = system_fixture(component)
      another_component = component_fixture()

      assert {:ok, system} = ComputerStore.add_component_to_system(system, another_component)

      assert {:ok, system} = ComputerStore.remove_component_from_system(system, component)
      refute ComputerStore.contains_component?(system, component)

      component = ComputerStore.get_component!(component.id)
      refute component.system_id

      another_system = system_fixture()

      assert {:ok, another_system} =
               ComputerStore.add_component_to_system(another_system, component)

      assert ComputerStore.contains_component?(another_system, component)
    end

    test "component knows what type of system, a server or a workstation, it can join" do
      workstation_component = component_fixture(system_type: :workstation)

      server_component = component_fixture(system_type: :server)
      server_system = system_fixture(server_component, type: :server)

      assert {:error, changeset} =
               ComputerStore.add_component_to_system(server_system, workstation_component)

      assert "Invalid component type for system; they must be compatiable" in errors_on(changeset).business_rule

      multi_system_component = component_fixture(system_type: :both)

      assert {:ok, server_system} =
               ComputerStore.add_component_to_system(server_system, multi_system_component)

      assert ComputerStore.contains_component?(server_system, multi_system_component)
    end

    test "system cannot add a component whose price exceeds the maximum" do
      component = component_fixture(price: "10.00")
      system = system_fixture(component, price: "20.00")

      another_component = component_fixture(price: "50.00")

      assert {:error, changeset} =
               ComputerStore.add_component_to_system(system, another_component)

      assert "Price exceeds maximum" in errors_on(changeset).business_rule
    end

    test "system cannot add a component whose weight exceeds the maximum" do
      component = component_fixture(weight: "100")
      system = system_fixture(component, weight: "200")

      another_component = component_fixture(weight: "300")

      assert {:error, changeset} =
               ComputerStore.add_component_to_system(system, another_component)

      assert "Weight exceeds maximum" in errors_on(changeset).business_rule
    end

    test "a component with domestic electrical requirements cannot go into a system intended for overseas use" do
      component = component_fixture(electrical_requirements: :overseas)
      system = system_fixture(component, electrical_requirements: :overseas)

      another_component = component_fixture(electrical_requirements: :domestic)

      assert {:error, changeset} =
               ComputerStore.add_component_to_system(system, another_component)

      assert "Component and system have incompatible electrical requirements" in errors_on(
               changeset
             ).business_rule
    end
  end
end
