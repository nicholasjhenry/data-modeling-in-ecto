defmodule NomifyWeb.PersonLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Directory
  alias Nomify.Directory.Person

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="person-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:email]} type="text" label="Email" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Person</.button>
          <.button navigate={return_path(@return_to, @person)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = Directory.get_person!(id)

    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, person)
    |> assign(:form, to_form(Directory.change_person(person)))
  end

  defp apply_action(socket, :new, _params) do
    person = %Person{}

    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, person)
    |> assign(:form, to_form(Directory.change_person(person)))
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = Directory.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.live_action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case Directory.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, person))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Directory.create_person(person_params) do
      {:ok, person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, person))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _person), do: ~p"/people"
  defp return_path("show", person), do: ~p"/people/#{person}"
end
