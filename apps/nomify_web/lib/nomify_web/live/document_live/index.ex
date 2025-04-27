defmodule NomifyWeb.DocumentLive.Index do
  use NomifyWeb, :live_view

  alias Nomify.Documents

  import Nomify.Result

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Documents
        <:actions>
          <.button variant="primary" navigate={~p"/documents/new"}>
            <.icon name="hero-plus" /> New Document
          </.button>
        </:actions>
      </.header>

      <.table
        id="documents"
        rows={@streams.documents}
        row_click={fn {_id, document} -> JS.navigate(~p"/documents/#{document}") end}
      >
        <:col :let={{_id, document}} label="Title">{document.title}</:col>
        <:col :let={{_id, document}} label="Publication date">{document.publication_date}</:col>
        <:col :let={{_id, document}} label="Security level">{document.security_level}</:col>
        <:action :let={{_id, document}}>
          <div class="sr-only">
            <.link navigate={~p"/documents/#{document}"}>Show</.link>
          </div>
          <.link navigate={~p"/documents/#{document}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, document}}>
          <.link
            phx-click={JS.push("delete", value: %{id: document.id}) |> hide("##{id}")}
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
    if connected?(socket) do
      Documents.subscribe_documents(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Documents")
     |> stream(:documents, Documents.list_documents())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    document = Documents.get_document!(id)

    case Documents.delete_document(socket.assigns.current_scope, document) do
      {:ok, _document} ->
        {:noreply, stream_delete(socket, :documents, document)}

      {:error, %Ecto.Changeset{} = changeset} ->
        [message | _rest] = errors_on(changeset).nominations

        socket =
          socket
          |> put_flash(:error, "Nominations " <> message)
          |> push_event("js-exec", %{id: "documents-#{id}", attr: "data-show"})

        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({type, %Documents.Document{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :documents, Documents.list_documents(), reset: true)}
  end
end
