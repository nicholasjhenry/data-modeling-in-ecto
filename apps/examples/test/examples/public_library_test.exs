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

    @invalid_attrs %{type: nil}

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert PublicLibrary.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      valid_attrs = %{type: :normal}

      assert {:ok, %Resource{} = resource} = PublicLibrary.create_resource(valid_attrs)
      assert resource.type == :normal
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

    @invalid_attrs %{type: nil}

    test "create_resource_hold/1 with valid data creates a resource_hold" do
      branch = branch_fixture()
      resource = resource_fixture()
      patron = patron_fixture()
      valid_attrs = %{type: :closed_ended, permit_resource_fees: true, pickup_day: "Monday"}

      assert {:ok, %ResourceHold{} = resource_hold} =
               PublicLibrary.create_resource_hold(branch, resource, patron, valid_attrs)

      assert resource_hold.type == :closed_ended
      assert resource_hold.permit_resource_fees == true
    end

    test "create_resource_hold/1 with invalid data returns error changeset" do
      branch = branch_fixture()
      resource = resource_fixture()
      patron = patron_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PublicLibrary.create_resource_hold(branch, resource, patron, @invalid_attrs)
    end
  end

  describe "placing a hold on a resource" do
    import Examples.PublicLibraryFixtures

    test "validates resource hold type" do
      branch = branch_fixture()
      resource = resource_fixture(permitted_resource_hold_types: ["closed_ended"])
      person = person_fixture()
      patron = patron_fixture(person, type: :researcher)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture(permitted_resource_hold_types: ["closed_ended"])
      attrs = %{type: :open_ended, pickup_day: "Monday"}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs)

      assert "This resource does not permit the resource hold type" in errors_on(changeset).business_rule
    end

    test "validates resource hold retrieval fee" do
      branch = branch_fixture()
      resource = resource_fixture(retrieval_fee: Decimal.new(20))
      person = person_fixture()
      patron = patron_fixture(person, permit_resource_fees: true)
      attrs = %{type: :closed_ended, pickup_day: "Monday", payment: Decimal.new(20)}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture(retrieval_fee: Decimal.new(20))
      attrs = %{type: :closed_ended, pickup_day: "Monday", payment: Decimal.new(10)}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs)

      assert "This resource hold does not have adequate payment" in errors_on(changeset).business_rule
    end
  end

  describe "placing a hold on a resource for a patron" do
    import Examples.PublicLibraryFixtures

    test "validates resource hold type for a regular patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person, type: :regular)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture()
      attrs = %{type: :open_ended}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs)

      assert "A regular patron can only place closed-ended holds on a resource" in errors_on(
               changeset
             ).business_rule
    end

    test "validate resource count for a regular patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person, type: :regular)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture()

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs,
                 max_resource_hold_count: 1
               )

      assert "A regular patron limited to the number of holds on a resource" in errors_on(
               changeset
             ).business_rule
    end

    test "validate resource count for a researcher patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person, type: :researcher)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture()

      assert {:ok, _resource_hold} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs,
                 max_resource_hold_count: 1
               )
    end

    test "validate age group for a patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture(born_on: ~D[2015-06-01])
      patron = patron_fixture(person)
      attrs = %{type: :closed_ended}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs,
                 current_date_time: ~U[2020-01-01 00:00:00Z]
               )

      assert "Patron must be an adult" in errors_on(changeset).business_rule
    end

    test "validate registration number for a patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person, registration_number: nil)
      attrs = %{type: :closed_ended}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      assert "A valid registration number is required for a patron" in errors_on(changeset).business_rule
    end

    test "validate state for a patron" do
      branch = branch_fixture()
      resource = resource_fixture()
      patron = patron_fixture()
      attrs = %{type: :closed_ended}

      {:ok, inactive_patron} = PublicLibrary.deactivate_patron(patron)

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, resource, inactive_patron, attrs)

      assert "A patron must be active" in errors_on(changeset).business_rule
    end

    test "validate resource fee conflict for a patron" do
      branch = branch_fixture()
      resource = resource_fixture(retrieval_fee: Decimal.new(100))
      person = person_fixture()
      patron = patron_fixture(person, permit_resource_fees: false)
      attrs = %{type: :closed_ended}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      assert "A resource fee is not permited by the patron" in errors_on(changeset).business_rule
    end

    test "validate override resource fee conflict for a patron" do
      branch = branch_fixture()
      resource = resource_fixture(retrieval_fee: Decimal.new(100))
      person = person_fixture()
      patron = patron_fixture(person, permit_resource_fees: false)

      attrs = %{
        type: :closed_ended,
        permit_resource_fees: true,
        payment: Decimal.new(100),
        pickup_day: "Monday"
      }

      assert {:ok, _resource_hold} =
               PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)
    end
  end

  describe "placing a hold on a resource at a branch" do
    import Examples.PublicLibraryFixtures

    test "branch validates resource hold type" do
      branch = branch_fixture(permitted_resource_holds_types: ["closed_ended"])
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person, type: :researcher)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture()
      attrs = %{type: :open_ended, pickup_day: "Monday"}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs)

      assert "This branch does not permit open-ended holds" in errors_on(changeset).business_rule
    end

    test "branch validates resource hold pickup day" do
      branch =
        branch_fixture(business_days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])

      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_resource = resource_fixture()
      attrs = %{type: :closed_ended, pickup_day: "Sunday"}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(branch, another_resource, patron, attrs)

      assert "This branch does not permit pickup on the selected day" in errors_on(changeset).business_rule
    end

    test "branch validates state" do
      branch = branch_fixture(state: :normal)
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_branch = branch_fixture(state: :reviewing_inventory)
      another_resource = resource_fixture()
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(
                 another_branch,
                 another_resource,
                 patron,
                 attrs
               )

      assert "This branch does not permit resource holds during inventory review" in errors_on(
               changeset
             ).business_rule
    end

    test "branch validates patron role" do
      branch = branch_fixture()
      resource = resource_fixture()
      person = person_fixture()
      patron = patron_fixture(person)
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      {:ok, _resource_hold} =
        PublicLibrary.placing_hold_on_resource(branch, resource, patron, attrs)

      another_branch = branch_fixture(permitted_patron_types_for_resource_holds: ["researcher"])
      another_resource = resource_fixture()
      attrs = %{type: :closed_ended, pickup_day: "Monday"}

      assert {:error, changeset} =
               PublicLibrary.placing_hold_on_resource(
                 another_branch,
                 another_resource,
                 patron,
                 attrs
               )

      assert "This branch permits resource holds for researcher patrons only" in errors_on(
               changeset
             ).business_rule
    end
  end
end
