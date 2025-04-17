defmodule Nomify.Documents.Nomination do
  use Ecto.Schema
  import Ecto.Changeset
  import Nomify.Result

  alias Nomify.Documents.Document
  alias Nomify.Resources.TeamMember

  schema "document_nominations" do
    field :comments, :string

    field :status, Ecto.Enum,
      values: [:pending, :in_review, :rejected, :approved],
      default: :pending

    field :nomination_date, :date, autogenerate: {Date, :utc_today, []}

    belongs_to :document, Document
    belongs_to :team_member, TeamMember

    timestamps()
  end

  @doc false
  def insert_changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments])
    |> validate_required([:comments])
  end

  def update_changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments, :status])
    |> validate_required([:comments, :status])
    |> validate_status
  end

  defp validate_status(changeset) do
    changeset.data
    |> do_validate_status(get_change(changeset, :status))
    |> put_result(changeset, :status)
  end

  defp do_validate_status(nomination, status) when status in [:pending, :in_review] do
    if nomination.status in [:pending, :in_review] do
      :ok
    else
      {:error, "Nomination already resolved. Cannot make #{status}"}
    end
  end

  defp do_validate_status(nomination, :approved) do
    if nomination.status in [:in_review, :approved] do
      :ok
    else
      {:error, "Nomination cannot be approved. Not under review"}
    end
  end

  defp do_validate_status(nomination, :rejected) do
    if nomination.status in [:in_review, :rejected] do
      :ok
    else
      {:error, "Nomination cannot be rejected. Not under review"}
    end
  end

  defp do_validate_status(_nomination, _no_change_in_status = nil) do
    :ok
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
