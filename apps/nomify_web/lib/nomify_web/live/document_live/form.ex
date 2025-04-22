defmodule NomifyWeb.DocumentLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Documents
  alias Nomify.Documents.Document

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage document records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="document-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input
          field={@form[:security_level]}
          type="select"
          label="Security level"
          prompt="Choose a value"
          options={Ecto.Enum.values(Nomify.Documents.Document, :security_level)}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Document</.button>
          <.button navigate={return_path(@return_to, @document)}>Cancel</.button>
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
    document = Documents.get_document!(id)

    socket
    |> assign(:page_title, "Edit Document")
    |> assign(:document, document)
    |> assign(:form, to_form(Documents.change_document(document)))
  end

  defp apply_action(socket, :new, _params) do
    document = %Document{}

    socket
    |> assign(:page_title, "New Document")
    |> assign(:document, document)
    |> assign(:form, to_form(Documents.change_document(document)))
  end

  @impl true
  def handle_event("validate", %{"document" => document_params}, socket) do
    changeset = Documents.change_document(socket.assigns.document, document_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"document" => document_params}, socket) do
    save_document(socket, socket.assigns.live_action, document_params)
  end

  defp save_document(socket, :edit, document_params) do
    case Documents.update_document(socket.assigns.document, document_params) do
      {:ok, document} ->
        {:noreply,
         socket
         |> put_flash(:info, "Document updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, document))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_document(socket, :new, document_params) do
    case Documents.create_document(document_params) do
      {:ok, document} ->
        {:noreply,
         socket
         |> put_flash(:info, "Document created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, document))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _document), do: ~p"/documents"
  defp return_path("show", document), do: ~p"/documents/#{document}"
end
