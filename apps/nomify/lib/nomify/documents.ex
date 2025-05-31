defmodule Nomify.Documents do
  @moduledoc """
  The Documents component is responsible for managing documents and nominations.
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
    |> preload_document()
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
      {:ok, document}
    end
  end

  def publish_document(scope, document) do
    with {:ok, document = %Document{}} <-
           document
           |> Repo.preload(:nominations)
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
           |> Document.delete_changeset()
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

  def test_document(scope) do
    attrs = %{title: "Test Document", security_level: :low}
    {:ok, document} = create_document(scope, attrs)
    document
  end

  def test_document_secret(scope) do
    attrs = %{title: "Test Document", security_level: :secret}
    {:ok, document} = create_document(scope, attrs)
    document
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

  def list_nominations_by_document(document) do
    query =
      from nomination in Nomination,
        where: nomination.document_id == ^document.id

    query
    |> Repo.all()
    |> preload_nomination()
  end

  def get_nomination!(document, id) do
    Nomination
    |> Repo.get_by!(document_id: document.id, id: id)
    |> preload_nomination()
  end

  defp preload_nomination(nomination) do
    Repo.preload(nomination, document: [], team_member: TeamMember.base_query())
  end

  def nominate_document(%Scope{} = scope, document, team_member, attrs \\ %{}, opts \\ []) do
    document = Repo.preload(document, latest_nomination: Nomination.latest())
    team_member = Repo.preload(team_member, :nominations)

    team_member_opts = Keyword.get(opts, :team_member, [])
    current_date = Keyword.get(opts, :current_date, Date.utc_today())

    with {:ok, nomination = %Nomination{}} <-
           %Nomination{}
           |> Nomination.insert_changeset(attrs, current_date)
           |> Nomination.put_document_changeset(document)
           |> Nomination.put_team_member_changeset(team_member, team_member_opts)
           |> Nomination.validate_conflict()
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
    current_date = Date.utc_today()

    nomination
    |> Nomination.insert_changeset(attrs, current_date)
    |> Nomination.update_changeset(attrs)
  end

  def nomination_equal?(lhs, rhs) do
    lhs.status == rhs.status and
      lhs.comments == rhs.comments and
      lhs.document_id == rhs.document_id and
      lhs.team_member_id == rhs.team_member_id
  end

  def test_old_nomination(scope, team_member) do
    document = test_document(scope)
    current_date = Date.new!(2001, 01, 01)

    {:ok, nomination} =
      nominate_document(scope, document, team_member, %{comment: "Old test nomination"},
        current_date: current_date
      )

    nomination
  end
end
