defmodule Nomify.Documents.Nomination do
  @moduledoc """
  A nomination is an event that represents the act of proposing a document for
  consideration by a team member.
  """

  use Nomify, :record

  alias Nomify.Documents.Document
  alias Nomify.Teams.TeamMember

  @typedoc """
  ## Fields

  A Nomination has these fields:

  - `comments` (descriptive): Notes or remarks about the nomination.
  - `status` (lifecycle state): The current state of the nomination process.
  - `nomination_date` (time): The date the nomination was created.

  ## Associations

  A Nomination associates with:

  - `document` (SpecificItem - Transaction): The document being proposed for consideration.
  - `team_member` (Role - Transaction): The team member proposing the document.
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          comments: String.t() | nil,
          status: :pending | :in_review | :rejected | :approved,
          nomination_date: Date.t() | nil,
          document_id: integer() | nil,
          document: Document.t() | Ecto.Association.NotLoaded.t(),
          team_member_id: integer() | nil,
          team_member: TeamMember.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "document_nominations" do
    # SECTION: Fields
    field :comments, :string

    # SOM: Principle 40 - Knowing Where in the Lifecycle
    # SOM: Principle 43 - Only Change State When Conducting Business
    #
    field :status, Ecto.Enum,
      values: [:pending, :in_review, :rejected, :approved],
      default: :pending

    field :nomination_date, :date

    # SECTION: Associations
    belongs_to :document, Document
    belongs_to :team_member, TeamMember

    timestamps()
  end

  # SECTION: Database Queries

  @doc false
  def latest(query \\ __MODULE__) do
    from query, order_by: [desc: :inserted_at], limit: 1
  end

  # SECTION: Field Changesets

  @doc false
  def insert_changeset(nomination, attrs, current_date) do
    nomination
    |> cast(attrs, [:comments])
    |> put_change(:nomination_date, current_date)
  end

  @doc false
  def update_changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments, :status])
    |> validate_required([:status])
    |> validate_status
  end

  # SECTION: Field Validations

  defp validate_status(changeset) do
    validate_change(changeset, :status, fn :status, next_status ->
      case {next_status, changeset.data.status} do
        {:pending, current_status} when current_status not in [:pending, :in_review] ->
          [status: "Nomination already resolved. Cannot make pending"]

        {:in_review, current_status} when current_status not in [:pending, :in_review] ->
          [status: "Nomination already resolved. Cannot make review"]

        {:approved, current_status} when current_status not in [:in_review, :approved] ->
          [status: "Nomination cannot be approved. Not under review"]

        {:rejected, current_status} when current_status not in [:in_review, :rejected] ->
          [status: "Nomination cannot be rejected. Not under review"]

        {_next_status, _current_status} ->
          []
      end
    end)
  end

  # SECTION: Assoc Changesets

  @doc false
  def put_document_changeset(changeset, document) do
    changeset
    |> put_assoc(:document, document)
    |> validate_assoc(:document, &Document.validate_nomination/2)
  end

  @doc false
  def put_team_member_changeset(changeset, team_member, opts \\ []) do
    changeset
    |> put_assoc(:team_member, team_member)
    |> validate_assoc(:team_member, &TeamMember.validate_nomination(&1, &2, opts))
  end

  # SECTION: Assoc Validations

  def validate_conflict(changeset) do
    document = get_assoc(changeset, :document, :struct)
    team_member = get_assoc(changeset, :team_member, :struct)

    Document.validate_nomination_conflict(document, team_member, changeset)
  end

  defimpl String.Chars do
    def to_string(nomination) do
      """
      Nomination on: #{nomination.nomination_date}
      Status: #{nomination.status}
      #{nomination.document}
      #{nomination.team_member}
      """
    end
  end
end
