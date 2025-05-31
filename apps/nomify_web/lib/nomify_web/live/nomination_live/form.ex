defmodule NomifyWeb.NominationLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Documents
  alias Nomify.Documents.Nomination
  alias Nomify.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title} - {to_string(@document)}
        <:subtitle>Use this form to manage nomination records in your database.</:subtitle>
      </.header>

      <%= if @live_action == :new do %>
        <.team_member_search_form team_member_name={@team_member_name} team_members={@team_members} />
      <% else %>
        <h2>{@team_member.name} ({@team_member.team.description})</h2>
      <% end %>

      <.form for={@form} id="nomination-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:comments]} type="textarea" label="Comments" />
        <%= if @live_action == :edit do %>
          <.input
            field={@form[:status]}
            type="select"
            label="Status"
            prompt="Choose a value"
            options={Ecto.Enum.values(Nomify.Documents.Nomination, :status)}
          />
        <% end %>
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Nomination</.button>
          <.button navigate={return_path(@return_to, @document, @nomination)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  def team_member_search_form(assigns) do
    ~H"""
    <h2>Find a team member</h2>
    <div id="team_members">
      <form id="team_members_search-form" phx-submit="search">
        <input
          type="text"
          name="team_member_name"
          value={@team_member_name}
          placeholder="Team Member Name"
          autofocus
          autocomplete="off"
          class="w-full input"
        />
      </form>

      <div class={["team_members", @team_members == [] && "dropdown"]}>
        <ul class="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-full">
          <li
            :for={team_member <- @team_members}
            id={"team_member-#{team_member.id}"}
            phx-click="team_member_selected"
            phx-value-id={team_member.id}
            phx-value-team_id={team_member.team.id}
          >
            <div>
              {to_string(team_member)}
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    document = Documents.get_document!(params["document_id"])

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:document, document)
     |> assign(:team_members, [])
     |> assign(:team_member_name, "")
     |> assign(:team_member, nil)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    nomination = Documents.get_nomination!(socket.assigns.document, id)

    socket
    |> assign(:page_title, "Edit Nomination")
    |> assign(:nomination, nomination)
    |> assign(:team_member, nomination.team_member)
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

  def handle_event("search", %{"team_member_name" => team_member_name}, socket) do
    team_members = Teams.search_team_members_by_name(team_member_name)

    {:noreply, assign(socket, :team_members, team_members)}
  end

  def handle_event("team_member_selected", %{"team_id" => team_id, "id" => id}, socket) do
    team = Teams.get_team!(team_id)
    team_member = Teams.get_team_member!(team, id)

    socket =
      socket
      |> assign(:team_member, team_member)
      |> assign(:team_member_name, to_string(team_member))
      |> assign(:team_members, [])

    {:noreply, socket}
  end

  defp save_nomination(socket, :edit, nomination_params) do
    case Documents.update_nomination(
           socket.assigns.current_scope,
           socket.assigns.nomination,
           nomination_params
         ) do
      {:ok, nomination} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nomination updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.return_to, socket.assigns.document, nomination)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_nomination(socket, :new, nomination_params) do
    case Documents.nominate_document(
           socket.assigns.current_scope,
           socket.assigns.document,
           socket.assigns.team_member,
           nomination_params
         ) do
      {:ok, nomination} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nomination created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.return_to, socket.assigns.document, nomination)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", document, _nomination), do: ~p"/documents/#{document}"

  defp return_path("show", document, nomination),
    do: ~p"/documents/#{document}/nominations/#{nomination}"
end
