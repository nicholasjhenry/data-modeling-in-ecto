defmodule NomifyWeb.TeamMemberLiveTest do
  use NomifyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nomify.ResourcesFixtures

  @create_attrs %{team_role: :admin, privileges: 42, security_level: :low}
  @update_attrs %{team_role: :chair, privileges: 43, security_level: :medium}
  @invalid_attrs %{team_role: nil, privileges: nil, security_level: nil}

  defp create_team_member(_) do
    team_member = team_member_fixture()

    %{team: team_member.team, team_member: team_member}
  end

  describe "Index" do
    setup [:create_team_member]

    test "lists all team_members", %{conn: conn, team: team} do
      {:ok, _index_live, html} = live(conn, ~p"/teams/#{team}")

      assert html =~ "Listing Team members"
    end

    test "saves new team_member", %{conn: conn} do
      team = team_fixture()
      person = person_fixture()

      {:ok, index_live, _html} = live(conn, ~p"/teams/#{team}")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Team member")
               |> render_click()
               |> follow_redirect(conn, ~p"/teams/#{team}/members/new")

      assert render(form_live) =~ "New Team member"

      assert form_live
             |> form("#people_search-form", %{person_name: person.name})
             |> render_submit()

      assert form_live
             |> element("#people-#{person.id}")
             |> render_click()

      assert form_live
             |> form("#team_member-form", team_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#team_member-form", team_member: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/teams/#{team}")

      html = render(index_live)
      assert html =~ "Team member created successfully"
    end

    test "updates team_member in listing", %{conn: conn, team: team, team_member: team_member} do
      {:ok, index_live, _html} = live(conn, ~p"/teams/#{team}")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#team_members-#{team_member.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/teams/#{team}/members/#{team_member}/edit")

      assert render(form_live) =~ "Edit Team member"

      assert form_live
             |> form("#team_member-form", team_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#team_member-form", team_member: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/teams/#{team}")

      html = render(index_live)
      assert html =~ "Team member updated successfully"
    end

    test "deletes team_member in listing", %{conn: conn, team: team, team_member: team_member} do
      {:ok, index_live, _html} = live(conn, ~p"/teams/#{team}")

      assert index_live
             |> element("#team_members-#{team_member.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#team_members-#{team_member.id}")
    end
  end

  describe "Show" do
    setup [:create_team_member]

    test "displays team_member", %{conn: conn, team: team, team_member: team_member} do
      {:ok, _show_live, html} = live(conn, ~p"/teams/#{team}/members/#{team_member}")

      assert html =~ "Show Team member"
    end

    test "updates team_member and returns to show", %{
      conn: conn,
      team: team,
      team_member: team_member
    } do
      {:ok, show_live, _html} = live(conn, ~p"/teams/#{team}/members/#{team_member}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(
                 conn,
                 ~p"/teams/#{team}/members/#{team_member}/edit?return_to=show"
               )

      assert render(form_live) =~ "Edit Team member"

      assert form_live
             |> form("#team_member-form", team_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#team_member-form", team_member: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/teams/#{team}/members/#{team_member}")

      html = render(show_live)
      assert html =~ "Team member updated successfully"
    end
  end
end
