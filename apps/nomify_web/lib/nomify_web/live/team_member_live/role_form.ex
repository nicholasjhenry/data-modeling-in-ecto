defmodule NomifyWeb.TeamMemberLive.RoleForm do
  use NomifyWeb, :live_view

  alias Nomify.Teams
  alias Nomify.Teams.TeamMember

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage team_member role in your database.</:subtitle>
      </.header>

      <h2>{@person.name} ({@person.title})</h2>

      <.form for={@form} id="team_member-form" phx-change="validate" phx-submit="save">
        <.input
          field={@form[:role]}
          type="select"
          label="Team role"
          prompt="Choose a value"
          options={Ecto.Enum.values(TeamMember, :role)}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary" disabled={@person == nil}>
            Save Team member
          </.button>
          <.button navigate={return_path(@return_to, @team, @team_member)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    team = Teams.get_team!(params["team_id"])
    team_member = Teams.get_team_member!(team, params["id"])
    form = to_form(Teams.change_team_member(team_member))

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:page_title, "Edit Team member's team role")
     |> assign(:team_member, team_member)
     |> assign(:team, team_member.team)
     |> assign(:person, team_member.person)
     |> assign(:form, form)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"team_member" => team_member_params}, socket) do
    changeset = Teams.change_team_member(socket.assigns.team_member, team_member_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"team_member" => team_member_params}, socket) do
    case Teams.update_team_member_role(
           socket.assigns.current_scope,
           socket.assigns.team_member,
           team_member_params
         ) do
      {:ok, team_member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team member's team role updated successfully")
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
