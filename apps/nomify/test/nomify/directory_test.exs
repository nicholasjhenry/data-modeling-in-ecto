defmodule Nomify.DirectoryTest do
  use Nomify.DataCase

  alias Nomify.Directory

  describe "people" do
    alias Nomify.Directory.Person

    import Nomify.AccountsFixtures, only: [user_scope_fixture: 0]
    import Nomify.DirectoryFixtures

    @invalid_attrs %{name: nil, title: nil, email: nil}

    test "list_people/0 returns all people" do
      scope = user_scope_fixture()
      person = person_fixture(scope)

      listed_people = Directory.list_people()

      assert person.id in Enum.map(listed_people, & &1.id)
    end

    test "get_person!/1 returns the person with given id" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert Directory.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      scope = user_scope_fixture()
      valid_attrs = %{name: "some name", title: "some title", email: "foo@example.com"}

      assert {:ok, %Person{} = person} = Directory.create_person(scope, valid_attrs)
      assert person.name == "some name"
      assert person.title == "some title"
      assert person.email == "foo@example.com"
    end

    test "create_person/1 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.create_person(scope, @invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        title: "some updated title",
        email: "foo.bar@example.com"
      }

      assert {:ok, %Person{} = person} = Directory.update_person(scope, person, update_attrs)
      assert person.name == "some updated name"
      assert person.title == "some updated title"
      assert person.email == "foo.bar@example.com"
    end

    test "update_person/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Directory.update_person(scope, person, @invalid_attrs)
      assert person == Directory.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert {:ok, %Person{}} = Directory.delete_person(scope, person)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert %Ecto.Changeset{} = Directory.change_person(person)
    end
  end
end
