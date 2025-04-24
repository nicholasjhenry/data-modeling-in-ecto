defmodule NomifyWeb.NominationLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest

  import Nomify.DocumentsFixtures
  import Nomify.TeamsFixtures

  @create_attrs %{comments: "some comments"}
  @update_attrs %{
    status: :in_review,
    comments: "some updated comments"
  }
  @invalid_attrs %{comments: nil}
  defp create_nomination(%{scope: scope}) do
    nomination = nomination_fixture(scope)

    %{document: nomination.document, nomination: nomination}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_nomination]

    test "saves new nomination", %{conn: conn, scope: scope} do
      document = document_fixture()

      team_member =
        scope
        |> team_member_fixture()
        |> update_team_member_privilege(:nominate)

      {:ok, index_live, _html} = live(conn, ~p"/documents/#{document}")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Nomination")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/#{document}/nominations/new")

      assert render(form_live) =~ "New Nomination"

      assert form_live
             |> form("#team_members_search-form", %{team_member_name: team_member.person.name})
             |> render_submit()

      assert form_live
             |> element("#team_member-#{team_member.id}")
             |> render_click()

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents/#{document}")

      html = render(index_live)
      assert html =~ "Nomination created successfully"
      assert html =~ "some comments"
    end

    test "updates nomination in listing", %{
      conn: conn,
      document: document,
      nomination: nomination
    } do
      {:ok, index_live, _html} = live(conn, ~p"/documents/#{document}")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#nominations-#{nomination.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/documents/#{document}/nominations/#{nomination}/edit")

      assert render(form_live) =~ "Edit Nomination"

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents/#{document}")

      html = render(index_live)
      assert html =~ "Nomination updated successfully"
      assert html =~ "some updated comments"
    end

    test "deletes nomination in listing", %{
      conn: conn,
      document: document,
      nomination: nomination
    } do
      {:ok, index_live, _html} = live(conn, ~p"/documents/#{document}")

      assert index_live |> element("#nominations-#{nomination.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#nominations-#{nomination.id}")
    end
  end

  describe "Show" do
    setup [:create_nomination]

    test "displays nomination", %{conn: conn, document: document, nomination: nomination} do
      {:ok, _show_live, html} = live(conn, ~p"/documents/#{document}/nominations/#{nomination}")

      assert html =~ "Show Nomination"
      assert html =~ nomination.comments
    end

    test "updates nomination and returns to show", %{
      conn: conn,
      document: document,
      nomination: nomination
    } do
      {:ok, show_live, _html} = live(conn, ~p"/documents/#{document}/nominations/#{nomination}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/documents/#{document}/nominations/#{nomination}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit Nomination"

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/documents/#{document}/nominations/#{nomination}")

      html = render(show_live)
      assert html =~ "Nomination updated successfully"
      assert html =~ "some updated comments"
    end
  end
end
