defmodule Examples.PublicLibraryTest do
  use Examples.DataCase

  alias Examples.PublicLibrary

  describe "public_library_branches" do
    alias Examples.PublicLibrary.Branch

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{name: nil}

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert PublicLibrary.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Branch{} = branch} = PublicLibrary.create_branch(valid_attrs)
      assert branch.name == "some name"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_branch(@invalid_attrs)
    end
  end

  describe "public_library_resources" do
    alias Examples.PublicLibrary.Resource

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{has_fee: nil}

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert PublicLibrary.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      valid_attrs = %{has_fee: true}

      assert {:ok, %Resource{} = resource} = PublicLibrary.create_resource(valid_attrs)
      assert resource.has_fee == true
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_resource(@invalid_attrs)
    end
  end

  describe "public_library_people" do
    alias Examples.PublicLibrary.Person

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{name: nil, born_on: nil}

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert PublicLibrary.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{name: "some name", born_on: ~D[2025-06-05]}

      assert {:ok, %Person{} = person} = PublicLibrary.create_person(valid_attrs)
      assert person.name == "some name"
      assert person.born_on == ~D[2025-06-05]
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_person(@invalid_attrs)
    end
  end

  describe "public_library_patrons" do
    alias Examples.PublicLibrary.Patron

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{type: nil, state: nil, registration_number: nil}

    test "list_public_library_patrons/0 returns all public_library_patrons" do
      patron = patron_fixture()
      assert PublicLibrary.list_public_library_patrons() == [patron]
    end

    test "get_patron!/1 returns the patron with given id" do
      patron = patron_fixture()
      assert PublicLibrary.get_patron!(patron.id) == patron
    end

    test "create_patron/1 with valid data creates a patron" do
      valid_attrs = %{type: :regular, state: :active, registration_number: "some registration_number"}

      assert {:ok, %Patron{} = patron} = PublicLibrary.create_patron(valid_attrs)
      assert patron.type == :regular
      assert patron.state == :active
      assert patron.registration_number == "some registration_number"
    end

    test "create_patron/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_patron(@invalid_attrs)
    end

    test "update_patron/2 with valid data updates the patron" do
      patron = patron_fixture()
      update_attrs = %{type: :researcher, state: :inactive, registration_number: "some updated registration_number"}

      assert {:ok, %Patron{} = patron} = PublicLibrary.update_patron(patron, update_attrs)
      assert patron.type == :researcher
      assert patron.state == :inactive
      assert patron.registration_number == "some updated registration_number"
    end

    test "update_patron/2 with invalid data returns error changeset" do
      patron = patron_fixture()
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.update_patron(patron, @invalid_attrs)
      assert patron == PublicLibrary.get_patron!(patron.id)
    end

    test "delete_patron/1 deletes the patron" do
      patron = patron_fixture()
      assert {:ok, %Patron{}} = PublicLibrary.delete_patron(patron)
      assert_raise Ecto.NoResultsError, fn -> PublicLibrary.get_patron!(patron.id) end
    end

    test "change_patron/1 returns a patron changeset" do
      patron = patron_fixture()
      assert %Ecto.Changeset{} = PublicLibrary.change_patron(patron)
    end
  end
end
