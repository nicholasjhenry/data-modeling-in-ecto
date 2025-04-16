defmodule Nomify.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nomify.Documents.Nomination

  schema "document_documents" do
    field :title, :string
    field :publication_date, :date
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]

    has_many :nominations, Nomination

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :publication_date, :security_level])
    |> validate_required([:title, :security_level])
    |> validate_title
  end

  defp validate_title(changeset) do
    validate_length(changeset, :title,
      min: 1,
      max: 255,
      message: "Document title cannot be longer than 255 characters"
    )
  end
end
