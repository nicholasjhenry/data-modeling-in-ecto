defmodule Nomify.DocumentsTest do
  use Nomify.DataCase

  alias Nomify.Documents

  import Nomify.AccountsFixtures, only: [user_scope_fixture: 0]

  describe "documents" do
    alias Nomify.Documents.Document

    import Nomify.DocumentsFixtures

    @invalid_attrs %{title: nil, publication_date: nil, security_level: nil}

    test "list_documents/0 returns all documents" do
      scope = user_scope_fixture()
      document = document_fixture(scope)
      assert [list_document] = Documents.list_documents()
      assert list_document.id == document.id
    end

    test "get_document!/1 returns the document with given id" do
      scope = user_scope_fixture()
      document = document_fixture(scope)
      assert Documents.document_equal?(Documents.get_document!(document.id), document)
    end

    test "create_document/1 with valid data creates a document" do
      scope = user_scope_fixture()
      valid_attrs = %{title: "some title", security_level: :low}

      assert {:ok, %Document{} = document} = Documents.create_document(scope, valid_attrs)
      assert document.title == "some title"
      assert document.security_level == :low
    end

    test "create_document/1 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(scope, @invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      update_attrs = %{
        title: "some updated title",
        security_level: :medium
      }

      assert {:ok, %Document{} = document} =
               Documents.update_document(scope, document, update_attrs)

      assert document.title == "some updated title"
      assert document.security_level == :medium
    end

    test "update_document/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Documents.update_document(scope, document, @invalid_attrs)

      assert Documents.document_equal?(document, Documents.get_document!(document.id))
    end

    test "publish_document/1 with approved document updates publication_date" do
      scope = user_scope_fixture()
      document = scope |> document_fixture() |> approve_document

      assert {:ok, %Document{} = document} = Documents.publish_document(scope, document)
      assert %Date{} = document.publication_date
    end

    test "publish_document/1 with unapproved document returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      assert {:error, changeset} = Documents.publish_document(scope, document)
      assert "Document not approved for publication." in errors_on(changeset).business_rule
    end

    test "publish_document/1 with previously published document returns error changeset" do
      scope = user_scope_fixture()
      document = scope |> document_fixture() |> approve_document()
      {:ok, published_document} = Documents.publish_document(scope, document)

      assert {:error, changeset} = Documents.publish_document(scope, published_document)
      assert "Document already published." in errors_on(changeset).business_rule
    end

    test "delete_document/1 deletes the document" do
      scope = user_scope_fixture()
      document = document_fixture(scope)
      assert {:ok, %Document{}} = Documents.delete_document(scope, document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end

  describe "nominations" do
    alias Nomify.Documents.Nomination

    import Nomify.DocumentsFixtures
    import Nomify.TeamsFixtures

    @invalid_attrs %{status: nil, comments: nil}

    test "get_nomination!/1 returns the nomination with given id" do
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)
      document = nomination.document

      assert Documents.nomination_equal?(
               Documents.get_nomination!(document, nomination.id),
               nomination
             )
    end

    test "nominate_document/1 with valid data creates a nomination" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_privilege(:nominate)

      valid_attrs = %{
        comments: "some comments"
      }

      assert {:ok, %Nomination{} = nomination} =
               Documents.nominate_document(document, team_member, valid_attrs)

      assert nomination.status == :pending
      assert nomination.comments == "some comments"
      assert %Date{} = nomination.nomination_date
    end

    test "nominate_document/1 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_privilege(:nominate)

      assert {:error, %Ecto.Changeset{}} =
               Documents.nominate_document(document, team_member, @invalid_attrs)
    end

    test "nominate_document/1 with nomination conflict returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope, security_level: :secret)

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_security_level(:low)

      valid_attrs = %{
        comments: "some comments"
      }

      assert {:error, changeset} =
               Documents.nominate_document(document, team_member, valid_attrs)

      assert "Security violation. Team member has improper security." in errors_on(changeset).business_rule
    end

    test "nominate_document/1 with team member without nominate privilege returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)
      team_member = team_member_fixture(scope)

      valid_attrs = %{comments: "some comments"}

      assert {:error, changeset} = Documents.nominate_document(document, team_member, valid_attrs)

      assert "Security violation. Team member cannot nominate." in errors_on(changeset).business_rule
    end

    test "nominate_document/1 with team member exceeding nominations returns error changeset" do
      scope = user_scope_fixture()
      document = document_fixture(scope)

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_privilege(:nominate)

      another_document = document_fixture(scope)

      _nomination =
        nomination_fixture(scope, %{}, document: another_document, team_member: team_member)

      valid_attrs = %{comments: "some comments"}
      opts = [team_member: [nomination_allowance: [max_documents: 1]]]

      assert {:error, changeset} =
               Documents.nominate_document(document, team_member, valid_attrs, opts)

      assert "Team member cannot nominate. Too many nominations." in errors_on(changeset).business_rule
    end

    test "nominate_document/1 with a document with an unresolved nomination returns error changeset" do
      scope = user_scope_fixture()
      document = scope |> document_fixture() |> nominate_document()

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_privilege(:nominate)

      valid_attrs = %{
        comments: "some comments"
      }

      assert {:error, changeset} = Documents.nominate_document(document, team_member, valid_attrs)

      assert "Nomination denied. Document has unresolved nomination." in errors_on(changeset).business_rule
    end

    test "update_nomination/2 with valid data updates the nomination" do
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)

      update_attrs = %{
        status: :in_review,
        comments: "some updated comments"
      }

      assert {:ok, %Nomination{} = nomination} =
               Documents.update_nomination(nomination, update_attrs)

      assert nomination.status == :in_review
      assert nomination.comments == "some updated comments"
    end

    test "update_nomination/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)
      document = nomination.document

      assert {:error, %Ecto.Changeset{}} = Documents.update_nomination(nomination, @invalid_attrs)

      assert Documents.nomination_equal?(
               nomination,
               Documents.get_nomination!(document, nomination.id)
             )
    end

    test "update_nomination/2 with invalid status returns error changeset" do
      # status: :pending
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)

      invalid_status_attrs = %{comment: "some updated comments", status: :approved}

      assert {:error, changeset} =
               Documents.update_nomination(nomination, invalid_status_attrs)

      assert "Nomination cannot be approved. Not under review" in errors_on(changeset).status
    end

    test "delete_nomination/1 deletes the nomination" do
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)
      document = nomination.document

      assert {:ok, %Nomination{}} = Documents.delete_nomination(nomination)

      assert_raise Ecto.NoResultsError, fn ->
        Documents.get_nomination!(document, nomination.id)
      end
    end

    test "change_nomination/1 returns a nomination changeset" do
      scope = user_scope_fixture()
      nomination = nomination_fixture(scope)
      assert %Ecto.Changeset{} = Documents.change_nomination(nomination)
    end
  end
end
