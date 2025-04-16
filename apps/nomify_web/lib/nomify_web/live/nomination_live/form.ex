defmodule NomifyWeb.NominationLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Documents
  alias Nomify.Documents.Nomination

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage nomination records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="nomination-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:comments]} type="textarea" label="Comments" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Nomify.Documents.Nomination, :status)}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Nomination</.button>
          <.button navigate={return_path(@return_to, @nomination)}>Cancel</.button>
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
    nomination = Documents.get_nomination!(id)

    socket
    |> assign(:page_title, "Edit Nomination")
    |> assign(:nomination, nomination)
    |> assign(:form, to_form(Documents.change_nomination(nomination)))
  end

  defp apply_action(socket, :new, _params) do
    nomination = %Nomination{}

    socket
    |> assign(:page_title, "New Nomination")
    |> assign(:nomination, nomination)
    |> assign(:form, to_form(Documents.change_nomination(nomination)))
  end

  @impl true
  def handle_event("validate", %{"nomination" => nomination_params}, socket) do
    changeset = Documents.change_nomination(socket.assigns.nomination, nomination_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"nomination" => nomination_params}, socket) do
    save_nomination(socket, socket.assigns.live_action, nomination_params)
  end

  defp save_nomination(socket, :edit, nomination_params) do
    case Documents.update_nomination(socket.assigns.nomination, nomination_params) do
      {:ok, nomination} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nomination updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, nomination))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_nomination(socket, :new, nomination_params) do
    case Documents.create_nomination(nomination_params) do
      {:ok, nomination} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nomination created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, nomination))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _nomination), do: ~p"/nominations"
  defp return_path("show", nomination), do: ~p"/nominations/#{nomination}"
end
