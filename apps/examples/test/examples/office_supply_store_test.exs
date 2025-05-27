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
end
