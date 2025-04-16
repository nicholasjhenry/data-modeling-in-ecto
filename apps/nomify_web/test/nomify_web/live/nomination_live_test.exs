defmodule NomifyWeb.NominationLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nomify.DocumentsFixtures

  @create_attrs %{status: :pending, comments: "some comments"}
  @update_attrs %{
    status: :in_review,
    comments: "some updated comments"
  }
  @invalid_attrs %{status: nil, comments: nil}
  defp create_nomination(_) do
    nomination = nomination_fixture()

    %{nomination: nomination}
  end

  describe "Index" do
    setup [:create_nomination]

    test "lists all nominations", %{conn: conn, nomination: nomination} do
      {:ok, _index_live, html} = live(conn, ~p"/nominations")

      assert html =~ "Listing Nominations"
      assert html =~ nomination.comments
    end

    test "saves new nomination", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/nominations")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Nomination")
               |> render_click()
               |> follow_redirect(conn, ~p"/nominations/new")

      assert render(form_live) =~ "New Nomination"

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/nominations")

      html = render(index_live)
      assert html =~ "Nomination created successfully"
      assert html =~ "some comments"
    end

    test "updates nomination in listing", %{conn: conn, nomination: nomination} do
      {:ok, index_live, _html} = live(conn, ~p"/nominations")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#nominations-#{nomination.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/nominations/#{nomination}/edit")

      assert render(form_live) =~ "Edit Nomination"

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/nominations")

      html = render(index_live)
      assert html =~ "Nomination updated successfully"
      assert html =~ "some updated comments"
    end

    test "deletes nomination in listing", %{conn: conn, nomination: nomination} do
      {:ok, index_live, _html} = live(conn, ~p"/nominations")

      assert index_live |> element("#nominations-#{nomination.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#nominations-#{nomination.id}")
    end
  end

  describe "Show" do
    setup [:create_nomination]

    test "displays nomination", %{conn: conn, nomination: nomination} do
      {:ok, _show_live, html} = live(conn, ~p"/nominations/#{nomination}")

      assert html =~ "Show Nomination"
      assert html =~ nomination.comments
    end

    test "updates nomination and returns to show", %{conn: conn, nomination: nomination} do
      {:ok, show_live, _html} = live(conn, ~p"/nominations/#{nomination}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/nominations/#{nomination}/edit?return_to=show")

      assert render(form_live) =~ "Edit Nomination"

      assert form_live
             |> form("#nomination-form", nomination: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#nomination-form", nomination: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/nominations/#{nomination}")

      html = render(show_live)
      assert html =~ "Nomination updated successfully"
      assert html =~ "some updated comments"
    end
  end
end
