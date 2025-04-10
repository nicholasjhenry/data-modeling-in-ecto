defmodule NomifyWeb.TeamMemberLive.Index do
  use NomifyWeb, :live_view

  alias Nomify.Resources

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Team members
        <:actions>
          <.button variant="primary" navigate={~p"/team_members/new"}>
            <.icon name="hero-plus" /> New Team member
          </.button>
        </:actions>
      </.header>

      <.table
        id="team_members"
        rows={@streams.team_members}
        row_click={fn {_id, team_member} -> JS.navigate(~p"/team_members/#{team_member}") end}
      >
        <:col :let={{_id, team_member}} label="Team role">{team_member.team_role}</:col>
        <:col :let={{_id, team_member}} label="Privileges">{team_member.privileges}</:col>
        <:col :let={{_id, team_member}} label="Security level">{team_member.security_level}</:col>
        <:action :let={{_id, team_member}}>
          <div class="sr-only">
            <.link navigate={~p"/team_members/#{team_member}"}>Show</.link>
          </div>
          <.link navigate={~p"/team_members/#{team_member}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, team_member}}>
          <.link
            phx-click={JS.push("delete", value: %{id: team_member.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Team members")
     |> stream(:team_members, Resources.list_team_members())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team_member = Resources.get_team_member!(id)
    {:ok, _} = Resources.delete_team_member(team_member)

    {:noreply, stream_delete(socket, :team_members, team_member)}
  end
end
