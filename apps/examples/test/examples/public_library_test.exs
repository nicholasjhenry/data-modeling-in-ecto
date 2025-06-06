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

    test "list_public_library_resources/0 returns all public_library_resources" do
      resource = resource_fixture()
      assert PublicLibrary.list_public_library_resources() == [resource]
    end

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert PublicLibrary.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      valid_attrs = %{has_fee: "some has_fee"}

      assert {:ok, %Resource{} = resource} = PublicLibrary.create_resource(valid_attrs)
      assert resource.has_fee == "some has_fee"
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.create_resource(@invalid_attrs)
    end

    test "update_resource/2 with valid data updates the resource" do
      resource = resource_fixture()
      update_attrs = %{has_fee: "some updated has_fee"}

      assert {:ok, %Resource{} = resource} = PublicLibrary.update_resource(resource, update_attrs)
      assert resource.has_fee == "some updated has_fee"
    end

    test "update_resource/2 with invalid data returns error changeset" do
      resource = resource_fixture()
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.update_resource(resource, @invalid_attrs)
      assert resource == PublicLibrary.get_resource!(resource.id)
    end

    test "delete_resource/1 deletes the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{}} = PublicLibrary.delete_resource(resource)
      assert_raise Ecto.NoResultsError, fn -> PublicLibrary.get_resource!(resource.id) end
    end

    test "change_resource/1 returns a resource changeset" do
      resource = resource_fixture()
      assert %Ecto.Changeset{} = PublicLibrary.change_resource(resource)
    end
  end
end
