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
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Document")
     |> assign(:document, Documents.get_document!(id))}
  end
end
