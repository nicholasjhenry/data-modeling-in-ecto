defmodule NomifyWeb.PersonLive.Index do
  use NomifyWeb, :live_view

  alias Nomify.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing People
        <:actions>
          <.button variant="primary" navigate={~p"/people/new"}>
            <.icon name="hero-plus" /> New Person
          </.button>
        </:actions>
      </.header>

      <.table
        id="people"
        rows={@streams.people}
        row_click={fn {_id, person} -> JS.navigate(~p"/people/#{person}") end}
      >
        <:col :let={{_id, person}} label="Title">{person.title}</:col>
        <:col :let={{_id, person}} label="Name">{person.name}</:col>
        <:col :let={{_id, person}} label="Email">{person.email}</:col>
        <:action :let={{_id, person}}>
          <div class="sr-only">
            <.link navigate={~p"/people/#{person}"}>Show</.link>
          </div>
          <.link navigate={~p"/people/#{person}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, person}}>
          <.link
            phx-click={JS.push("delete", value: %{id: person.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing People")
     |> stream(:people, Directory.list_people())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Directory.get_person!(id)
    {:ok, _} = Directory.delete_person(person)

    {:noreply, stream_delete(socket, :people, person)}
  end
end
