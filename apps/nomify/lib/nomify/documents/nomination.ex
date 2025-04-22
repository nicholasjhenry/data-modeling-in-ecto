defmodule Nomify.Documents.Nomination do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  import Nomify.Result

  alias Nomify.Documents.Document
  alias Nomify.Teams.TeamMember

  schema "document_nominations" do
    # SECTION: Fields
    field :comments, :string

    # NOTE: Principle 40: Knowing Where in the Lifecycle
    #
    # In a person, place, or thing object, make the lifecycle state a property derived
    # from event collaborators. In an event, make the lifecycle state a property,
    # unless it is derived from follow-up events.
    #
    # NOTE: Principle 43: Only Change State When Conducting Business
    #
    # Allow only conduct business services to change an object’s lifecycle or
    # operational state properties.
    #
    field :status, Ecto.Enum,
      values: [:pending, :in_review, :rejected, :approved],
      default: :pending

    field :nomination_date, :date, autogenerate: {Date, :utc_today, []}

    # SECTION: Associations
    belongs_to :document, Document
    belongs_to :team_member, TeamMember

    timestamps()
  end

  # SECTION: Database Queries

  def latest(query \\ __MODULE__) do
    from query, order_by: [desc: :inserted_at], limit: 1
  end

  # SECTION: Field Changesets

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

  # SECTION: Field Validations

  defp validate_status(changeset) do
    changeset.data
    |> check_next_status(get_change(changeset, :status))
    |> put_result(changeset, :status)
  end

  @doc false
  def check_next_status(nomination, next_status) do
    case {next_status, nomination.status} do
      {:pending, current_status} when current_status not in [:pending, :in_review] ->
        {:error, "Nomination already resolved. Cannot make pending"}

      {:in_review, current_status} when current_status not in [:pending, :in_review] ->
        {:error, "Nomination already resolved. Cannot make review"}

      {:approved, current_status} when current_status not in [:in_review, :approved] ->
        {:error, "Nomination cannot be approved. Not under review"}

      {:rejected, current_status} when current_status not in [:in_review, :rejected] ->
        {:error, "Nomination cannot be rejected. Not under review"}

      {_next_status, _current_status} ->
        :ok
    end
  end

  # SECTION: Assoc Changesets

  @doc false
  def put_document(changeset, document) do
    changeset
    |> put_assoc(:document, document)
    |> validate_document()
  end

  @doc false
  def put_team_member(changeset, team_member, opts \\ []) do
    changeset
    |> put_assoc(:team_member, team_member)
    |> validate_team_member(opts)
  end

  # SECTION: Assoc Validations

  defp validate_document(changeset) do
    changeset = maybe_validate_nomination_conflict(changeset)

    changeset
    |> get_assoc(:document, :struct)
    |> Document.check_nomination()
    |> put_result(changeset, :business_rule)
  end

  defp validate_team_member(changeset, opts) do
    changeset = maybe_validate_nomination_conflict(changeset)

    changeset
    |> get_assoc(:team_member, :struct)
    |> TeamMember.check_nomination(opts)
    |> put_result(changeset, :business_rule)
  end

  # NOTE: functions prefixed with `maybe_` may or may not perform the function
  defp maybe_validate_nomination_conflict(changeset) do
    document = get_assoc(changeset, :document, :struct)
    team_member = get_assoc(changeset, :team_member, :struct)

    if document && team_member do
      document
      |> Document.check_nomination_conflict(team_member)
      |> put_result(changeset, :business_rule)
    else
      changeset
    end
  end
end
