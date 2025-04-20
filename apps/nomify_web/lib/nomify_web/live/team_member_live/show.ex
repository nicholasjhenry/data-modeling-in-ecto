defmodule NomifyWeb.TeamMemberLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Resources

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Team member {@team_member.id}
        <:subtitle>This is a team_member record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/teams/#{@team}"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/teams/#{@team}/members/#{@team_member}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit team_member
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Team role">{@team_member.role}</:item>
        <:item title="Privileges">{@team_member.privileges}</:item>
        <:item title="Security level">{@team_member.security_level}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"team_id" => team_id, "id" => id}, _session, socket) do
    team = Resources.get_team!(team_id)
    team_member = Resources.get_team_member!(team, id)

    {:ok,
     socket
     |> assign(:page_title, "Show Team member")
     |> assign(:team, team)
     |> assign(:team_member, team_member)}
  end
end
