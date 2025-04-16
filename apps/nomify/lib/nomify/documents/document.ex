defmodule Nomify.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "document_documents" do
    field :title, :string
    field :publication_date, :date
    field :security_level, Ecto.Enum, values: [:low, :medium, :high, :secret]

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :publication_date, :security_level])
    |> validate_required([:title, :publication_date, :security_level])
  end
end
