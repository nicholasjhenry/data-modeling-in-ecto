defmodule Nomify.ResourcesTest do
  use Nomify.DataCase

  alias Nomify.Resources

  describe "people" do
    alias Nomify.Resources.Person

    import Nomify.ResourcesFixtures

    @invalid_attrs %{name: nil, title: nil, email: nil}

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Resources.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Resources.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{name: "some name", title: "some title", email: "foo@example.com"}

      assert {:ok, %Person{} = person} = Resources.create_person(valid_attrs)
      assert person.name == "some name"
      assert person.title == "some title"
      assert person.email == "foo@example.com"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        email: "foo.bar@example.com"
      }

      assert {:ok, %Person{} = person} = Resources.update_person(person, update_attrs)
      assert person.name == "some updated name"
      assert person.title == "some updated title"
      assert person.email == "foo.bar@example.com"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_person(person, @invalid_attrs)
      assert person == Resources.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Resources.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Resources.change_person(person)
    end
  end
end
