defmodule NomifyWeb.PersonLive.Show do
  use NomifyWeb, :live_view

  alias Nomify.Resources

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
    {:ok,
     socket
     |> assign(:page_title, "Show Person")
     |> assign(:person, Resources.get_person!(id))}
  end
end
