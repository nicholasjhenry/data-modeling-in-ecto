defmodule Nomify.Resources.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resource_teams" do
    field :description, :string
    field :format, Ecto.Enum, values: [:none, :single, :multiple]

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:description, :format])
    |> validate_required([:description, :format])
  end
end
