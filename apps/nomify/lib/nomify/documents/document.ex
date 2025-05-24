defmodule Nomify.Documents.Document do
  @moduledoc """
  A document is a record of internally authored content and may include related
  nominations or approvals.
  """

  use Nomify, :record

  alias Nomify.Documents.Nomination
  alias Nomify.SecurityLevel

  @typedoc """
  ## Fields

  A Document has these fields:

  - `title` (descriptive): The title of the document.
  - `publication_date` (time): The date the document was published.
  - `security_level` (type): The security classification of the document.

  ## Associations

  A Document associates with:

  - `nominations` (Specific Item - Transaction): The nominations related to the document.
  - `latest_nomination` (Specific Item - Transaction): The most recent nomination for the document.
  """
  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          publication_date: Date.t() | nil,
          security_level: SecurityLevel.t(),
          nominations: list(Nomination.t()),
          latest_nomination: Nomination.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "document_documents" do
    # SECTION: Fields
    field :title, :string
    field :publication_date, :date
    field :security_level, Ecto.Enum, values: SecurityLevel.values()

    # SECTION: Associations
    has_many :nominations, Nomination
    has_one :latest_nomination, Nomination

    timestamps()
  end

  # SECTION: State Queries

  @doc false
  def approved?(document) do
    !!Enum.find(document.nominations, &(&1.status == :approved))
  end

  @doc false
  def published?(document) do
    document.publication_date != nil
  end

  # SECTION: Field Changesets

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :security_level])
    # Example: Logical field validations
    |> validate_required([:title, :security_level])
    # Example: Business field validation
    |> validate_title
  end

  @doc false
  def publish_changeset(document, attrs) do
    document
    |> cast(attrs, [:publication_date])
    |> validate_publication_date
  end

  @doc false
  def delete_changeset(document) do
    document
    |> change()
    |> no_assoc_constraint(:nominations)
  end

  # SECTION: Field Validations

  defp validate_title(changeset) do
    validate_length(changeset, :title,
      min: 1,
      max: 255,
      message: "Document title cannot be longer than 255 characters"
    )
  end

  defp validate_publication_date(changeset) do
    changeset.data
    |> check_publishable()
    |> put_result(changeset, :business_rule)
  end

  # SECTION: Field Checks

  @doc false
  def check_publishable(document) do
    cond do
      !approved?(document) -> {:error, "Document not approved for publication."}
      published?(document) -> {:error, "Document already published."}
      true -> :ok
    end
  end

  # SECTION: Assoc Checks

  @doc false
  def check_nomination(document) do
    if document.latest_nomination && document.latest_nomination.status in [:pending, :approved] do
      {:error, "Nomination denied. Document has unresolved nomination."}
    else
      :ok
    end
  end

  @doc false
  # Example: Conflict check
  def check_nomination_conflict(document, team_member) do
    if SecurityLevel.compare(document.security_level, team_member.security_level) == :gt do
      {:error, "Security violation. Team member has improper security."}
    else
      :ok
    end
  end

  defimpl String.Chars do
    def to_string(document) do
      "📄 #{document.title} (#{document.security_level})"
    end
  end
end
