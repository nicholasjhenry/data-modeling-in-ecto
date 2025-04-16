defmodule Nomify.DocumentsTest do
  use Nomify.DataCase

  alias Nomify.Documents

  describe "documents" do
    alias Nomify.Documents.Document

    import Nomify.DocumentsFixtures

    @invalid_attrs %{title: nil, publication_date: nil, security_level: nil}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Documents.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{title: "some title", publication_date: ~D[2025-04-15], security_level: :low}

      assert {:ok, %Document{} = document} = Documents.create_document(valid_attrs)
      assert document.title == "some title"
      assert document.publication_date == ~D[2025-04-15]
      assert document.security_level == :low
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()

      update_attrs = %{
        title: "some updated title",
        publication_date: ~D[2025-04-16],
        security_level: :medium
      }

      assert {:ok, %Document{} = document} = Documents.update_document(document, update_attrs)
      assert document.title == "some updated title"
      assert document.publication_date == ~D[2025-04-16]
      assert document.security_level == :medium
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
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
end
