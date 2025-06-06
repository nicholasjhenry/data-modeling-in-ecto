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

    test "get_patron!/1 returns the patron with given id" do
      patron = patron_fixture()
      fetched_patron = PublicLibrary.get_patron!(patron.id)
      assert PublicLibrary.patron_equal?(patron, fetched_patron)
    end

    test "create_patron/1 with valid data creates a patron" do
      person = person_fixture()

      valid_attrs = %{
        type: :regular,
        registration_number: "some registration_number"
      }

      assert {:ok, %Patron{} = patron} = PublicLibrary.create_patron(person, valid_attrs)
      assert patron.type == :regular
      assert patron.state == :active
      assert patron.registration_number == "some registration_number"
    end

    test "create_patron/1 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_patron(person, @invalid_attrs)
    end
  end

  describe "public_library_resource_holds" do
    alias Examples.PublicLibrary.ResourceHold

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{type: nil, permit_resource_fees: nil}

    test "create_resource_hold/1 with valid data creates a resource_hold" do
      branch = branch_fixture()
      resource = resource_fixture()
      valid_attrs = %{type: :open_ended, permit_resource_fees: true}

      assert {:ok, %ResourceHold{} = resource_hold} =
               PublicLibrary.create_resource_hold(branch, resource, valid_attrs)

      assert resource_hold.type == :open_ended
      assert resource_hold.permit_resource_fees == true
    end

    test "create_resource_hold/1 with invalid data returns error changeset" do
      branch = branch_fixture()
      resource = resource_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PublicLibrary.create_resource_hold(branch, resource, @invalid_attrs)
    end
  end
end
