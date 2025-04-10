defmodule NomifyWeb.PersonLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nomify.ResourcesFixtures

  @create_attrs %{name: "some name", title: "some title", email: "foo@example.com"}
  @update_attrs %{
    name: "some updated name",
    title: "some updated title",
    email: "foo.bar@example.com"
  }
  @invalid_attrs %{name: nil, title: nil, email: nil}
  defp create_person(_) do
    person = person_fixture()

    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all people", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/people")

      assert html =~ "Listing People"
      assert html =~ person.title
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Person")
               |> render_click()
               |> follow_redirect(conn, ~p"/people/new")

      assert render(form_live) =~ "New Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#person-form", person: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/people")

      html = render(index_live)
      assert html =~ "Person created successfully"
      assert html =~ "some title"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#people-#{person.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/people/#{person}/edit")

      assert render(form_live) =~ "Edit Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#person-form", person: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/people")

      html = render(index_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("#people-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#people-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/people/#{person}")

      assert html =~ "Show Person"
      assert html =~ person.title
    end

    test "updates person and returns to show", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/people/#{person}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/people/#{person}/edit?return_to=show")

      assert render(form_live) =~ "Edit Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#person-form", person: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/people/#{person}")

      html = render(show_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated title"
    end
  end
end
