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

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:description, :format])
    |> validate_required([:description, :format])
  end

  @doc false
  def validate_chair_eligibility(team) do
    case team.format do
      :none ->
        {:error, "Tried to add chair team member to no chairs team."}

      :single ->
        chair_count =
          team
          |> filter_chairs()
          |> Enum.count()

        if chair_count > 0 do
          {:error, "Tried to add another chair team member to single chair team."}
        else
          :ok
        end

      :multiple ->
        :ok
    end
  end

  defp filter_chairs(team) do
    Enum.filter(team.team_members, &(&1.team_role == :chair))
  end
end
