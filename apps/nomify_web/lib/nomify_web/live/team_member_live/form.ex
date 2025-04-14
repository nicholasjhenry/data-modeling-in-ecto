defmodule NomifyWeb.TeamMemberLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Resources
  alias Nomify.Resources.TeamMember

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage team_member records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="team_member-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:person_id]} type="number" label="Person ID" />

        <.input
          field={@form[:team_role]}
          type="select"
          label="Team role"
          prompt="Choose a value"
          options={Ecto.Enum.values(Nomify.Resources.TeamMember, :team_role)}
        />
        <.input field={@form[:privileges]} type="number" label="Privileges" />
        <.input
          field={@form[:security_level]}
          type="select"
          label="Security level"
          prompt="Choose a value"
          options={Ecto.Enum.values(Nomify.Resources.TeamMember, :security_level)}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Team member</.button>
          <.button navigate={return_path(@return_to, @team, @team_member)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    team = Resources.get_team!(params["team_id"])

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:team, team)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    team_member = Resources.get_team_member!(socket.assigns.team, id)

    socket
    |> assign(:page_title, "Edit Team member")
    |> assign(:team_member, team_member)
    |> assign(:form, to_form(Resources.change_team_member(team_member)))
  end

  defp apply_action(socket, :new, _params) do
    team_member = %TeamMember{}

    socket
    |> assign(:page_title, "New Team member")
    |> assign(:team_member, team_member)
    |> assign(:form, to_form(Resources.change_team_member(team_member)))
  end

  @impl true
  def handle_event("validate", %{"team_member" => team_member_params}, socket) do
    changeset = Resources.change_team_member(socket.assigns.team_member, team_member_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"team_member" => team_member_params}, socket) do
    save_team_member(socket, socket.assigns.live_action, team_member_params)
  end

  defp save_team_member(socket, :edit, team_member_params) do
    case Resources.update_team_member(socket.assigns.team_member, team_member_params) do
      {:ok, team_member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team member updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.return_to, socket.assigns.team, team_member)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_team_member(socket, :new, team_member_params) do
    person = Resources.get_person!(team_member_params["person_id"])

    case Resources.create_team_member(socket.assigns.team, person, team_member_params) do
      {:ok, team_member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team member created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.return_to, socket.assigns.team, team_member)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("show", team, team_member), do: ~p"/teams/#{team}/members/#{team_member}"
  defp return_path("index", team, _team_member), do: ~p"/teams/#{team}"
end
