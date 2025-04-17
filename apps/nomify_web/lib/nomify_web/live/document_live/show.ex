defmodule NomifyWeb.DocumentLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Documents

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Document {@document.id}
        <:subtitle>This is a document record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/documents"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/documents/#{@document}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit document
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@document.title}</:item>
        <:item title="Publication date">{@document.publication_date}</:item>
        <:item title="Security level">{@document.security_level}</:item>
      </.list>

      <.nominations document={@document} streams={@streams} />
    </Layouts.app>
    """
  end

  defp nominations(assigns) do
    ~H"""
    <.header>
      Listing Nominations
      <:actions>
        <.button variant="primary" navigate={~p"/documents/#{@document}/nominations/new"}>
          <.icon name="hero-plus" /> New Nomination
        </.button>
      </:actions>
    </.header>

    <.table
      id="nominations"
      rows={@streams.nominations}
      row_click={
        fn {_id, nomination} -> JS.navigate(~p"/documents/#{@document}/nominations/#{nomination}") end
      }
    >
      <:col :let={{_id, nomination}} label="Nominated by">{nomination.team_member.person.name}</:col>
      <:col :let={{_id, nomination}} label="Comments">{nomination.comments}</:col>
      <:col :let={{_id, nomination}} label="Status">{nomination.status}</:col>
      <:col :let={{_id, nomination}} label="Nomination date">{nomination.nomination_date}</:col>
      <:action :let={{_id, nomination}}>
        <div class="sr-only">
          <.link navigate={~p"/documents/#{@document}/nominations/#{nomination}"}>Show</.link>
        </div>
        <.link navigate={~p"/documents/#{@document}/nominations/#{nomination}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, nomination}}>
        <.link
          phx-click={
            JS.push("delete_nomination", value: %{document_id: @document.id, id: nomination.id})
            |> hide("##{id}")
          }
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
    document = Documents.get_document!(id)

    {:ok,
     socket
     |> assign(:page_title, "Show Document")
     |> assign(:document, document)
     |> stream(:nominations, document.nominations)}
  end

  @impl true
  def handle_event("delete_nomination", %{"id" => id}, socket) do
    nomination = Documents.get_nomination!(socket.assigns.document, id)
    {:ok, _} = Documents.delete_nomination(nomination)

    {:noreply, stream_delete(socket, :nominations, nomination)}
  end
end
