defmodule Nomify.Documents.Nomination do
  use Ecto.Schema
  import Ecto.Changeset

  schema "document_nominations" do
    field :comments, :string
    field :status, Ecto.Enum, values: [:pending, :in_review, :rejected, :approved]
    field :nomination_date, :date, autogenerate: {Date, :utc_today, []}
    field :document_id, :id
    field :team_member_id, :id

    timestamps()
  end

  @doc false
  def changeset(nomination, attrs) do
    nomination
    |> cast(attrs, [:comments, :status])
    |> validate_required([:comments, :status])
  end
end
