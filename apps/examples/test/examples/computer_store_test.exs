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
end
