defmodule NomifyWeb.DocumentLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nomify.DocumentsFixtures
  import Nomify.TeamsFixtures

  @create_attrs %{title: "some title", security_level: :low}
  @update_attrs %{
    title: "some updated title",
    security_level: :medium
  }
  @invalid_attrs %{title: nil, security_level: nil}
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

    test "nominates document", %{conn: conn, document: document} do
      team_member = team_member_fixture() |> update_team_member_privilege(:nominate)

      {:ok, show_live, html} = live(conn, ~p"/documents/#{document}")

      assert html =~ "Show Document"

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "New Nomination")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/#{document}/nominations/new")

      assert form_live
             |> form("#team_members_search-form", %{team_member_name: team_member.person.name})
             |> render_submit()

      assert form_live
             |> element("#team_member-#{team_member.id}")
             |> render_click()

      assert {:ok, show_live, _html} =
               form_live
               |> form("#nomination-form", nomination: %{comments: "some comments"})
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents/#{document}")

      html = render(show_live)
      assert html =~ "Nomination created successfully"
    end

    test "publishes document", %{conn: conn, document: document} do
      {:ok, show_live, html} = live(conn, ~p"/documents/#{document}")

      assert html =~ "Show Document"

      show_live
      |> element("button", "Publish document")
      |> render_click()

      html = render(show_live)
      assert html =~ "Document not approved for publication."

      _document = approve_document(document)

      {:ok, show_live, _html} = live(conn, ~p"/documents/#{document}")

      assert show_live
             |> element("button", "Publish document")
             |> render_click()

      html = render(show_live)
      assert html =~ "Document published successfully"
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
