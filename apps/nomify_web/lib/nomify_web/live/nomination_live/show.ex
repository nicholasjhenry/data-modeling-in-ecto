defmodule NomifyWeb.NominationLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Documents

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Nomination {@nomination.id}
        <:subtitle>This is a nomination record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/nominations"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/nominations/#{@nomination}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit nomination
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Comments">{@nomination.comments}</:item>
        <:item title="Status">{@nomination.status}</:item>
        <:item title="Nomination date">{@nomination.nomination_date}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Nomination")
     |> assign(:nomination, Documents.get_nomination!(id))}
  end
end
