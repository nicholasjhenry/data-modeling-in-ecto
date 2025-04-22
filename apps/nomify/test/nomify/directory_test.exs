defmodule Nomify.DirectoryTest do
  use Nomify.DataCase

  alias Nomify.Directory

  describe "people" do
    alias Nomify.Directory.Person

    import Nomify.DirectoryFixtures

    @invalid_attrs %{name: nil, title: nil, email: nil}

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Directory.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Directory.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{name: "some name", title: "some title", email: "foo@example.com"}

      assert {:ok, %Person{} = person} = Directory.create_person(valid_attrs)
      assert person.name == "some name"
      assert person.title == "some title"
      assert person.email == "foo@example.com"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        email: "foo.bar@example.com"
      }

      assert {:ok, %Person{} = person} = Directory.update_person(person, update_attrs)
      assert person.name == "some updated name"
      assert person.title == "some updated title"
      assert person.email == "foo.bar@example.com"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_person(person, @invalid_attrs)
      assert person == Directory.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Directory.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Directory.change_person(person)
    end
  end
end
