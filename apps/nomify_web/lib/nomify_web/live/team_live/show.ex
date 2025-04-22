defmodule NomifyWeb.TeamLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Team {@team.id}
        <:subtitle>This is a team record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/teams"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/teams/#{@team}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit team
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">{@team.description}</:item>
        <:item title="Format">{@team.format}</:item>
      </.list>

      <.team_members team={@team} streams={@streams} />
    </Layouts.app>
    """
  end

  defp team_members(assigns) do
    ~H"""
    <.header>
      Listing Team members
      <:actions>
        <.button variant="primary" navigate={~p"/teams/#{@team}/members/new"}>
          <.icon name="hero-plus" /> New Team member
        </.button>
      </:actions>
    </.header>
    <.table
      id="team_members"
      rows={@streams.team_members}
      row_click={fn {_id, team_member} -> JS.navigate(~p"/teams/#{@team}/members/#{team_member}") end}
    >
      <:col :let={{_id, team_member}} label="Name">{team_member.name}</:col>
      <:col :let={{_id, team_member}} label="Team role">{team_member.role}</:col>
      <:col :let={{_id, team_member}} label="Privileges">{team_member.privileges}</:col>
      <:col :let={{_id, team_member}} label="Security level">{team_member.security_level}</:col>
      <:action :let={{_id, team_member}}>
        <div class="sr-only">
          <.link navigate={~p"/teams/#{@team}/members/#{team_member}"}>Show</.link>
        </div>
        <.link data-role="edit" navigate={~p"/teams/#{@team}/members/#{team_member}/edit"}>
          Edit
        </.link>
        <.link
          data-role="edit-team-role"
          navigate={~p"/teams/#{@team}/members/#{team_member}/role/edit"}
        >
          Edit team role
        </.link>
        <.link
          data-role="edit-privileges"
          navigate={~p"/teams/#{@team}/members/#{team_member}/privileges/edit"}
        >
          Edit privileges
        </.link>
      </:action>
      <:action :let={{id, team_member}}>
        <.link
          phx-click={JS.push("delete_team_member", value: %{id: team_member.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    team = Teams.get_team!(id)

    {:ok,
     socket
     |> assign(:page_title, "Show Team")
     |> assign(:team, team)
     |> stream(:team_members, team.team_members)}
  end

  @impl true
  def handle_event("delete_team_member", %{"id" => id}, socket) do
    team_member = Teams.get_team_member!(socket.assigns.team, id)
    {:ok, _} = Teams.delete_team_member(team_member)

    {:noreply, stream_delete(socket, :team_members, team_member)}
  end
end
