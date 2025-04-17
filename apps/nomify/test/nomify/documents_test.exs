defmodule Nomify.DocumentsTest do
  use Nomify.DataCase

  alias Nomify.Documents

  describe "documents" do
    alias Nomify.Documents.Document

    import Nomify.DocumentsFixtures

    @invalid_attrs %{title: nil, publication_date: nil, security_level: nil}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert [list_document] = Documents.list_documents()
      assert list_document.id == document.id
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.document_equal?(Documents.get_document!(document.id), document)
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{title: "some title", security_level: :low}

      assert {:ok, %Document{} = document} = Documents.create_document(valid_attrs)
      assert document.title == "some title"
      assert document.security_level == :low
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()

      update_attrs = %{
        title: "some updated title",
        security_level: :medium
      }

      assert {:ok, %Document{} = document} = Documents.update_document(document, update_attrs)
      assert document.title == "some updated title"
      assert document.security_level == :medium
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert Documents.document_equal?(document, Documents.get_document!(document.id))
    end

    test "publish_document/1 with approved document updates publication_date" do
      document = document_fixture() |> approve_document

      assert {:ok, %Document{} = document} = Documents.publish_document(document)
      assert %Date{} = document.publication_date
    end

    test "publish_document/1 with unapproved document returns error changeset" do
      document = document_fixture()

      assert {:error, changeset} = Documents.publish_document(document)
      assert "Document not approved for publication." in errors_on(changeset).business_rule
    end

    test "publish_document/1 with previously published document returns error changeset" do
      document = document_fixture() |> approve_document()
      {:ok, published_document} = Documents.publish_document(document)

      assert {:error, changeset} = Documents.publish_document(published_document)
      assert "Document already published." in errors_on(changeset).business_rule
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end

  describe "nominations" do
    alias Nomify.Documents.Nomination

    import Nomify.DocumentsFixtures
    import Nomify.ResourcesFixtures

    @invalid_attrs %{status: nil, comments: nil}

    test "get_nomination!/1 returns the nomination with given id" do
      nomination = nomination_fixture()
      document = nomination.document

      assert Documents.nomination_equal?(
               Documents.get_nomination!(document, nomination.id),
               nomination
             )
    end

    test "create_nomination/1 with valid data creates a nomination" do
      document = document_fixture()
      team_member = team_member_fixture()

      valid_attrs = %{
        comments: "some comments"
      }

      assert {:ok, %Nomination{} = nomination} =
               Documents.create_nomination(document, team_member, valid_attrs)

      assert nomination.status == :pending
      assert nomination.comments == "some comments"
      assert %Date{} = nomination.nomination_date
    end

    test "create_nomination/1 with invalid data returns error changeset" do
      document = document_fixture()
      team_member = team_member_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Documents.create_nomination(document, team_member, @invalid_attrs)
    end

    test "create_nomination/1 with nomination conflict returns error changeset" do
      document = document_fixture(security_level: :secret)

      team_member =
        team_member_fixture()
        |> update_team_member_security_level(:low)

      valid_attrs = %{
        comments: "some comments"
      }

      assert {:error, changeset} =
               Documents.create_nomination(document, team_member, valid_attrs)

      assert "Security violation. Team member has improper security." in errors_on(changeset).business_rule
    end

    test "update_nomination/2 with valid data updates the nomination" do
      nomination = nomination_fixture()

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
      nomination = nomination_fixture()
      document = nomination.document

      assert {:error, %Ecto.Changeset{}} = Documents.update_nomination(nomination, @invalid_attrs)

      assert Documents.nomination_equal?(
               nomination,
               Documents.get_nomination!(document, nomination.id)
             )
    end

    test "update_nomination/2 with invalid status returns error changeset" do
      # status: :pending
      nomination = nomination_fixture()

      invalid_status_attrs = %{comment: "some updated comments", status: :approved}

      assert {:error, changeset} =
               Documents.update_nomination(nomination, invalid_status_attrs)

      assert "Nomination cannot be approved. Not under review" in errors_on(changeset).status
    end

    test "delete_nomination/1 deletes the nomination" do
      nomination = nomination_fixture()
      document = nomination.document

      assert {:ok, %Nomination{}} = Documents.delete_nomination(nomination)

      assert_raise Ecto.NoResultsError, fn ->
        Documents.get_nomination!(document, nomination.id)
      end
    end

    test "change_nomination/1 returns a nomination changeset" do
      nomination = nomination_fixture()
      assert %Ecto.Changeset{} = Documents.change_nomination(nomination)
    end
  end
end
