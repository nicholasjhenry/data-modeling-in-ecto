defmodule Nomify.Resources.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Resources.TeamMember

  schema "resource_teams" do
    field :description, :string
    field :format, Ecto.Enum, values: [:none, :single, :multiple]

    # NOTE: group - member (whole - part)
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
