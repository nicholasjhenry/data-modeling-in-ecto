defmodule NomifyWeb.DocumentLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nomify.DocumentsFixtures

  @create_attrs %{title: "some title", publication_date: "2025-04-15", security_level: :low}
  @update_attrs %{
    title: "some updated title",
    publication_date: "2025-04-16",
    security_level: :medium
  }
  @invalid_attrs %{title: nil, publication_date: nil, security_level: nil}
  defp create_document(_) do
    document = document_fixture()

    %{document: document}
  end

  describe "Index" do
    setup [:create_document]

    test "lists all documents", %{conn: conn, document: document} do
      {:ok, _index_live, html} = live(conn, ~p"/documents")

      assert html =~ "Listing Documents"
      assert html =~ document.title
    end

    test "saves new document", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/documents")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Document")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/new")

      assert render(form_live) =~ "New Document"

      assert form_live
             |> form("#document-form", document: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#document-form", document: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents")

      html = render(index_live)
      assert html =~ "Document created successfully"
      assert html =~ "some title"
    end

    test "updates document in listing", %{conn: conn, document: document} do
      {:ok, index_live, _html} = live(conn, ~p"/documents")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#documents-#{document.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/#{document}/edit")

      assert render(form_live) =~ "Edit Document"

      assert form_live
             |> form("#document-form", document: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#document-form", document: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents")

      html = render(index_live)
      assert html =~ "Document updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes document in listing", %{conn: conn, document: document} do
      {:ok, index_live, _html} = live(conn, ~p"/documents")

      assert index_live |> element("#documents-#{document.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#documents-#{document.id}")
    end
  end

  describe "Show" do
    setup [:create_document]

    test "displays document", %{conn: conn, document: document} do
      {:ok, _show_live, html} = live(conn, ~p"/documents/#{document}")

      assert html =~ "Show Document"
      assert html =~ document.title
    end

    test "updates document and returns to show", %{conn: conn, document: document} do
      {:ok, show_live, _html} = live(conn, ~p"/documents/#{document}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/#{document}/edit?return_to=show")

      assert render(form_live) =~ "Edit Document"

      assert form_live
             |> form("#document-form", document: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#document-form", document: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents/#{document}")

      html = render(show_live)
      assert html =~ "Document updated successfully"
      assert html =~ "some updated title"
    end
  end
end
