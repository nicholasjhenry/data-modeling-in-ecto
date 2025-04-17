defmodule Nomify.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset
  import Nomify.Result

  alias Nomify.Documents.Nomination
  alias Nomify.SecurityLevel

  schema "document_documents" do
    field :title, :string
    field :publication_date, :date
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]

    has_many :nominations, Nomination

    timestamps()
  end

  def approved?(document) do
    !!Enum.find(document.nominations, &(&1.status == :approved))
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :security_level])
    |> validate_required([:title, :security_level])
    |> validate_title
  end

  def publish_changeset(document, attrs) do
    document
    |> cast(attrs, [:publication_date])
    |> validate_publication_date
  end

  defp validate_publication_date(changeset) do
    changeset.data
    |> do_validate_publication_date()
    |> put_result(changeset, :business_rule)
  end

  defp do_validate_publication_date(document) do
    cond do
      !approved?(document) -> {:error, "Document not approved for publication."}
      document.publication_date != nil -> {:error, "Document already published."}
      true -> :ok
    end
  end

  defp validate_title(changeset) do
    validate_length(changeset, :title,
      min: 1,
      max: 255,
      message: "Document title cannot be longer than 255 characters"
    )
  end

  def validate_put_nomination_conflict(document, team_member, changeset) do
    if SecurityLevel.compare(document.security_level, team_member.security_level) == :gt do
      add_error(
        changeset,
        :business_rule,
        "Security violation. Team member has improper security."
      )
    else
      changeset
    end
  end
end
