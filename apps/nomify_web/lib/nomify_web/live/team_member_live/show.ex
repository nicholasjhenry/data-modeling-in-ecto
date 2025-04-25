defmodule NomifyWeb.TeamMemberLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Team member {@team_member.id}: {@team_member.name} ({@team_member.title})
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
    if connected?(socket) do
      Teams.subscribe_team_members(socket.assigns.current_scope)
    end

    team = Teams.get_team!(team_id)
    team_member = Teams.get_team_member!(team, id)

    {:ok,
     socket
     |> assign(:page_title, "Show Team member")
     |> assign(:team, team)
     |> assign(:team_member, team_member)}
  end

  @impl true
  def handle_info(
        {:updated, %Teams.TeamMember{id: id} = team_member},
        %{assigns: %{team_member: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :team_member, team_member)}
  end

  def handle_info(
        {:deleted, %Teams.TeamMember{id: id}},
        %{assigns: %{team_member: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current team member was deleted.")
     |> push_navigate(to: ~p"/teams")}
  end

  def handle_info({type, %Teams.TeamMember{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
