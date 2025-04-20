defmodule Nomify.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset
  import Nomify.Result

  alias Nomify.Documents.Nomination
  alias Nomify.SecurityLevel

  schema "document_documents" do
    # SECTION: Fields
    field :title, :string
    field :publication_date, :date
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]

    # SECTION: Associations
    has_many :nominations, Nomination

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
    |> validate_required([:title, :security_level])
    |> validate_title
  end

  @doc false
  def publish_changeset(document, attrs) do
    document
    |> cast(attrs, [:publication_date])
    |> validate_publication_date
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

  defp check_publishable(document) do
    cond do
      !approved?(document) -> {:error, "Document not approved for publication."}
      published?(document) -> {:error, "Document already published."}
      true -> :ok
    end
  end

  # SECTION: Assoc Validations

  @doc false
  def check_nomination_conflict(document, team_member) do
    if SecurityLevel.compare(document.security_level, team_member.security_level) == :gt do
      {:error, "Security violation. Team member has improper security."}
    else
      :ok
    end
  end
end
