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
    if connected?(socket) do
      Documents.subscribe_nominations(socket.assigns.current_scope)
    end

    document = Documents.get_document!(document_id)

    {:ok,
     socket
     |> assign(:page_title, "Show Nomination")
     |> assign(:document, document)
     |> assign(:nomination, Documents.get_nomination!(document, id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    nomination = Documents.get_nomination!(socket.assigns.document, id)
    {:ok, _} = Documents.delete_nomination(socket.assigns.current_scope, nomination)

    {:noreply, stream_delete(socket, :nominations, nomination)}
  end

  @impl true
  def handle_info(
        {:updated, %Documents.Nomination{id: id} = nomination},
        %{assigns: %{nomination: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :nomination, nomination)}
  end

  def handle_info(
        {:deleted, %Documents.Nomination{id: id, document_id: document_id}},
        %{assigns: %{nomination: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current nomination was deleted.")
     |> push_navigate(to: ~p"/documents/#{document_id}/")}
  end

  def handle_info({type, %Documents.Nomination{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
