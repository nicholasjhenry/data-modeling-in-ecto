defmodule NomifyWeb.NominationLive.Index do
  use NomifyWeb, :live_view

  alias Nomify.Documents

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Nominations
        <:actions>
          <.button variant="primary" navigate={~p"/nominations/new"}>
            <.icon name="hero-plus" /> New Nomination
          </.button>
        </:actions>
      </.header>

      <.table
        id="nominations"
        rows={@streams.nominations}
        row_click={fn {_id, nomination} -> JS.navigate(~p"/nominations/#{nomination}") end}
      >
        <:col :let={{_id, nomination}} label="Comments">{nomination.comments}</:col>
        <:col :let={{_id, nomination}} label="Status">{nomination.status}</:col>
        <:col :let={{_id, nomination}} label="Nomination date">{nomination.nomination_date}</:col>
        <:action :let={{_id, nomination}}>
          <div class="sr-only">
            <.link navigate={~p"/nominations/#{nomination}"}>Show</.link>
          </div>
          <.link navigate={~p"/nominations/#{nomination}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, nomination}}>
          <.link
            phx-click={JS.push("delete", value: %{id: nomination.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Nominations")
     |> stream(:nominations, Documents.list_nominations())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    nomination = Documents.get_nomination!(id)
    {:ok, _} = Documents.delete_nomination(nomination)

    {:noreply, stream_delete(socket, :nominations, nomination)}
  end
end
