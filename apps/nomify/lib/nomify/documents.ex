defmodule Nomify.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  alias Nomify.Accounts.Scope
  alias Nomify.Documents.Document
  alias Nomify.Teams.TeamMember

  def subscribe_documents(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:documents")
  end

  defp broadcast_documents(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:documents", message)
  end

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

  def create_document(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, document = %Document{}} <-
           %Document{}
           |> Document.changeset(attrs)
           |> Repo.insert() do
      broadcast_documents(scope, {:created, document})
      {:ok, preload_document(document)}
    end
  end

  def publish_document(scope, document) do
    with {:ok, document = %Document{}} <-
           document
           |> Document.publish_changeset(%{publication_date: Date.utc_today()})
           |> Repo.update() do
      broadcast_documents(scope, {:updated, document})
      {:ok, document}
    end
  end

  def update_document(%Scope{} = scope, %Document{} = document, attrs) do
    with {:ok, document = %Document{}} <-
           document
           |> Document.changeset(attrs)
           |> Repo.update() do
      broadcast_documents(scope, {:updated, document})
      {:ok, document}
    end
  end

  def delete_document(%Scope{} = scope, %Document{} = document) do
    with {:ok, document = %Document{}} <-
           document
           |> Ecto.Changeset.change()
           |> Ecto.Changeset.no_assoc_constraint(:nominations)
           |> Repo.delete() do
      broadcast_documents(scope, {:deleted, document})
      {:ok, document}
    end
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

  def subscribe_nominations(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Nomify.PubSub, "user:#{key}:nominations")
  end

  defp broadcast_nominations(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Nomify.PubSub, "user:#{key}:nominations", message)
  end

  def list_nominations do
    Repo.all(Nomination)
  end

  def get_nomination!(document, id) do
    Nomination
    |> Repo.get_by!(document_id: document.id, id: id)
    |> Repo.preload(team_member: TeamMember.base_query())
  end

  def nominate_document(%Scope{} = scope, document, team_member, attrs, opts \\ []) do
    document = Repo.preload(document, latest_nomination: Nomination.latest())
    team_member = Repo.preload(team_member, :nominations)

    team_member_opts = Keyword.get(opts, :team_member, [])

    with {:ok, nomination = %Nomination{}} <-
           %Nomination{}
           |> Nomination.insert_changeset(attrs)
           |> Nomination.put_document(document)
           |> Nomination.put_team_member(team_member, team_member_opts)
           |> Repo.insert() do
      broadcast_nominations(scope, {:created, nomination})
      {:ok, nomination}
    end
  end

  def update_nomination(%Scope{} = scope, %Nomination{} = nomination, attrs) do
    with {:ok, nomination = %Nomination{}} <-
           nomination
           |> Nomination.update_changeset(attrs)
           |> Repo.update() do
      broadcast_nominations(scope, {:updated, nomination})
      {:ok, nomination}
    end
  end

  def delete_nomination(%Scope{} = scope, %Nomination{} = nomination) do
    with {:ok, nomination = %Nomination{}} <-
           Repo.delete(nomination) do
      broadcast_nominations(scope, {:deleted, nomination})
      {:ok, nomination}
    end
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
