defmodule Examples.PublicLibraryTest do
  use Examples.DataCase

  alias Examples.PublicLibrary

  describe "public_library_branches" do
    alias Examples.PublicLibrary.Branch

    import Examples.PublicLibraryFixtures

    @invalid_attrs %{name: nil}

    test "list_public_library_branches/0 returns all public_library_branches" do
      branch = branch_fixture()
      assert PublicLibrary.list_public_library_branches() == [branch]
    end

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

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Branch{} = branch} = PublicLibrary.update_branch(branch, update_attrs)
      assert branch.name == "some updated name"
    end

    test "update_branch/2 with invalid data returns error changeset" do
      branch = branch_fixture()
      assert {:error, %Ecto.Changeset{}} = PublicLibrary.update_branch(branch, @invalid_attrs)
      assert branch == PublicLibrary.get_branch!(branch.id)
    end

    test "delete_branch/1 deletes the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{}} = PublicLibrary.delete_branch(branch)
      assert_raise Ecto.NoResultsError, fn -> PublicLibrary.get_branch!(branch.id) end
    end

    test "change_branch/1 returns a branch changeset" do
      branch = branch_fixture()
      assert %Ecto.Changeset{} = PublicLibrary.change_branch(branch)
    end
  end
end
