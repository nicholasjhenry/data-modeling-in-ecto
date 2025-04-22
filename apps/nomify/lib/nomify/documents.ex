defmodule Nomify.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  alias Nomify.Documents.Document
  alias Nomify.Resources.TeamMember

  def list_documents do
    Repo.all(Document)
  end

  def get_document!(id) do
    Document
    |> Repo.get!(id)
    |> Repo.preload(nominations: [team_member: TeamMember.base_query()])
  end

  defp preload_document(document) do
    Repo.preload(document, nominations: [team_member: TeamMember.base_query()])
  end

  def create_document(attrs \\ %{}) do
    result =
      %Document{}
      |> Document.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, document} -> {:ok, preload_document(document)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def publish_document(document) do
    document
    |> Document.publish_changeset(%{publication_date: Date.utc_today()})
    |> Repo.update()
  end

  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  def change_document(%Document{} = document, attrs \\ %{}) do
    Document.changeset(document, attrs)
  end

  def document_equal?(lhs, rhs) do
    (lhs.title == rhs.title and
       lhs.security_level == rhs.security_level and
       (!!lhs.publication_date and !!rhs.publication_date and
          Date.compare(lhs.publication_date, rhs.publication_date) == :eq)) or
      (is_nil(lhs.publication_date) and is_nil(rhs.publication_date))
  end

  alias Nomify.Documents.Nomination

  def list_nominations do
    Repo.all(Nomination)
  end

  def get_nomination!(document, id) do
    Nomination
    |> Repo.get_by!(document_id: document.id, id: id)
    |> Repo.preload(team_member: TeamMember.base_query())
  end

  def nominate_document(document, team_member, attrs, opts \\ []) do
    document = Repo.preload(document, latest_nomination: Nomination.latest())
    team_member = Repo.preload(team_member, :nominations)

    team_member_opts = Keyword.get(opts, :team_member, [])

    %Nomination{}
    |> Nomination.insert_changeset(attrs)
    |> Nomination.put_document(document)
    |> Nomination.put_team_member(team_member, team_member_opts)
    |> Repo.insert()
  end

  def update_nomination(%Nomination{} = nomination, attrs) do
    nomination
    |> Nomination.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_nomination(%Nomination{} = nomination) do
    Repo.delete(nomination)
  end

  def change_nomination(%Nomination{} = nomination, attrs \\ %{}) do
    nomination
    |> Nomination.insert_changeset(attrs)
    |> Nomination.update_changeset(attrs)
  end

  def nomination_equal?(lhs, rhs) do
    lhs.status == rhs.status and
      lhs.comments == rhs.comments and
      lhs.document_id == rhs.document_id and
      lhs.team_member_id == rhs.team_member_id
  end
end
