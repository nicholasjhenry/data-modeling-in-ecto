defmodule Nomify.Documents.Nomination do
  use Ecto.Schema
  import Ecto.Changeset

  schema "document_nominations" do
    field :comments, :string
    field :status, Ecto.Enum, values: [:pending, :in_review, :rejected, :approved]
    field :nomination_date, :date
    field :document_id, :id
    field :team_member_id, :id

    timestamps()
  end

  @doc false
  def changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments, :status, :nomination_date])
    |> validate_required([:comments, :status, :nomination_date])
  end
end
