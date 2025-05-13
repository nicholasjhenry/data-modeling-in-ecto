defmodule Nomify.Teams.Team do
  @moduledoc """
  A Team is a structured group within an organization, characterized by its format and associated members.
  """

  use Nomify, :record

  alias Nomify.Teams.TeamMember

  @typedoc """
  ## Fields

  A Team has these fields:

  - `description` (descriptive): A description of the team.
  - `format` (type): The format of the team, which can be none, single, or multiple.

  ## Associations

  A Team associates with:

  - `team_members` (Group - Member): Represents the members belonging to the team.
  """
  @type t :: %__MODULE__{
          id: integer(),
          description: String.t(),
          format: :none | :single | :multiple,
          team_members: [TeamMember.t()],
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "team_teams" do
    # SECTION: Fields
    field :description, :string
    field :format, Ecto.Enum, values: [:none, :single, :multiple]

    # SECTION: Associations
    has_many :team_members, TeamMember

    timestamps()
  end

  # SECTION: State Queries

  @doc false
  def get_chairs(team) do
    Enum.filter(team.team_members, &(&1.role == :chair))
  end

  # SECTION: Field Changesets

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:description, :format])
    |> validate_required([:description, :format])
  end

  # SECTION: Assoc Validations

  @doc false
  def check_chair_eligibility(team) do
    case team.format do
      :none ->
        {:error, "Tried to add chair team member to no chairs team."}

      :single ->
        chairs = get_chairs(team)

        if Enum.count(chairs) > 0 do
          {:error, "Tried to add another chair team member to single chair team."}
        else
          :ok
        end

      :multiple ->
        :ok
    end
  end
end
