defmodule NomifyWeb.PersonLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Directory

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Person {@person.id}
        <:subtitle>This is a person record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/people"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/people/#{@person}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit person
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@person.title}</:item>
        <:item title="Name">{@person.name}</:item>
        <:item title="Email">{@person.email}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Directory.subscribe_people(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Person")
     |> assign(:person, Directory.get_person!(id))}
  end

  @impl true
  def handle_info(
        {:updated, %Directory.Person{id: id} = person},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :person, person)}
  end

  def handle_info(
        {:deleted, %Directory.Person{id: id}},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current person was deleted.")
     |> push_navigate(to: ~p"/people")}
  end

  def handle_info({type, %Directory.Person{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
