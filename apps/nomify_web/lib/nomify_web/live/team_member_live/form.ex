defmodule NomifyWeb.TeamMemberLive.Form do
  use NomifyWeb, :live_view

  alias Nomify.Directory
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

      <%= if @live_action == :new do %>
        <.person_search_form person_name={@person_name} people={@people} />
      <% else %>
        <h2>{@person.name} ({@person.title})</h2>
      <% end %>

      <.form for={@form} id="team_member-form" phx-change="validate" phx-submit="save">
        <.errors field={@form[:business_rule]} title="Business Rule Errors" />
        <%= if @live_action == :edit do %>
          <.input
            field={@form[:security_level]}
            type="select"
            label="Security level"
            prompt="Choose a value"
            options={Ecto.Enum.values(Nomify.Resources.TeamMember, :security_level)}
          />
        <% end %>
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

  def person_search_form(assigns) do
    ~H"""
    <h2>Find a Person</h2>
    <div id="people">
      <form id="people_search-form" phx-submit="search">
        <input
          type="text"
          name="person_name"
          value={@person_name}
          placeholder="Person Name"
          autofocus
          autocomplete="off"
          class="w-full input"
        />
      </form>

      <div class={["people", @people == [] && "dropdown"]}>
        <ul class="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-full">
          <li
            :for={person <- @people}
            id={"people-#{person.id}"}
            phx-click="person_selected"
            phx-value-id={person.id}
          >
            <div>
              {person.name} ({person.title})
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    team = Resources.get_team!(params["team_id"])

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:team, team)
     |> assign(:people, [])
     |> assign(:person_name, "")
     |> assign(:person, nil)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    team_member = Resources.get_team_member!(socket.assigns.team, id)

    socket
    |> assign(:page_title, "Edit Team member")
    |> assign(:team_member, team_member)
    |> assign(:person, team_member.person)
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

  def handle_event("save", params, socket) do
    save_team_member(socket, socket.assigns.live_action, params["team_member"])
  end

  def handle_event("search", %{"person_name" => person_name}, socket) do
    people = Directory.search_people_by_name(person_name)

    {:noreply, assign(socket, :people, people)}
  end

  def handle_event("person_selected", %{"id" => id}, socket) do
    person = Directory.get_person!(id)

    socket =
      socket
      |> assign(:person, person)
      |> assign(:person_name, person.name)
      |> assign(:people, [])

    {:noreply, socket}
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

  defp save_team_member(socket, :new, _team_member_params) do
    case Resources.create_team_member(socket.assigns.team, socket.assigns.person) do
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
