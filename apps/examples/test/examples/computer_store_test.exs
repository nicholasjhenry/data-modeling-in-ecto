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
      valid_attrs = %{
        type: :server,
        price: "120.5",
        weight: "120.5",
        electrical_requirements: :domestic,
        approval_state: :pending
      }

      assert {:ok, %System{} = system} = ComputerStore.create_system(valid_attrs)
      assert system.type == :server
      assert system.price == Decimal.new("120.5")
      assert system.weight == Decimal.new("120.5")
      assert system.electrical_requirements == :domestic
      assert system.approval_state == :pending
    end

    test "create_system/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ComputerStore.create_system(@invalid_attrs)
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

    test "add a component to a system" do
      system = system_fixture()
      component = component_fixture()

      assert {:ok, system} = ComputerStore.add_component_to_system(system, component)
      assert List.first(system.components).id == component.id
    end
  end
end
