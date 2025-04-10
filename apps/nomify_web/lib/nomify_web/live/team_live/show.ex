defmodule NomifyWeb.TeamLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Resources

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
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Team")
     |> assign(:team, Resources.get_team!(id))}
  end
end
