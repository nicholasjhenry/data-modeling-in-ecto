defmodule Nomify.Documents.Nomination do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Documents.Document
  alias Nomify.Resources.TeamMember
  alias Nomify.SecurityLevel

  schema "document_nominations" do
    field :comments, :string
    field :status, Ecto.Enum, values: [:pending, :in_review, :rejected, :approved]
    field :nomination_date, :date, autogenerate: {Date, :utc_today, []}

    belongs_to :document, Document
    belongs_to :team_member, TeamMember

    timestamps()
  end

  @doc false
  def changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments, :status])
    |> validate_required([:comments, :status])
  end

  @doc false
  def put_document(changeset, document) do
    changeset
    |> put_assoc(:document, document)
    |> validate_put_document(document)
  end

  @doc false
  def put_team_member(changeset, team_member) do
    changeset
    |> put_assoc(:team_member, team_member)
    |> validate_put_team_member(team_member)
  end

  defp validate_put_document(changeset, document) do
    validate_put_nomination_conflict(
      changeset,
      document,
      get_assoc(changeset, :team_member, :struct)
    )
  end

  defp validate_put_team_member(changeset, team_member) do
    validate_put_nomination_conflict(
      changeset,
      get_assoc(changeset, :document, :struct),
      team_member
    )
  end

  defp validate_put_nomination_conflict(
         changeset,
         %Document{} = document,
         %TeamMember{} = team_member
       ) do
    Document.validate_put_nomination_conflict(document, team_member, changeset)
  end

  defp validate_put_nomination_conflict(changeset, _document, _team_member) do
    changeset
  end
end
