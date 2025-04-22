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
          <.button navigate={~p"/documents/#{@document}"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/documents/#{@document}/nominations/#{@nomination}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit nomination
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Nominated by">{to_string(@nomination.team_member)}</:item>
        <:item title="Comments">{@nomination.comments}</:item>
        <:item title="Status">{@nomination.status}</:item>
        <:item title="Nomination date">{@nomination.nomination_date}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"document_id" => document_id, "id" => id}, _session, socket) do
    document = Documents.get_document!(document_id)

    {:ok,
     socket
     |> assign(:page_title, "Show Nomination")
     |> assign(:document, document)
     |> assign(:nomination, Documents.get_nomination!(document, id))}
  end
end
