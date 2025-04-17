defmodule Nomify.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Nomify.Repo

  alias Nomify.Documents.Document

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(id) do
    Document
    |> Repo.get!(id)
    |> Repo.preload(nominations: [team_member: :person])
  end

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(attrs \\ %{}) do
    result =
      %Document{}
      |> Document.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, document} -> {:ok, Repo.preload(document, nominations: [:team_member, :person])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def publish_document(document) do
    document
    |> Document.publish_changeset(%{publication_date: Date.utc_today()})
    |> Repo.update()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{data: %Document{}}

  """
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

  @doc """
  Returns the list of nominations.

  ## Examples

      iex> list_nominations()
      [%Nomination{}, ...]

  """
  def list_nominations do
    Repo.all(Nomination)
  end

  @doc """
  Gets a single nomination.

  Raises `Ecto.NoResultsError` if the Nomination does not exist.

  ## Examples

      iex> get_nomination!(123)
      %Nomination{}

      iex> get_nomination!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nomination!(document, id) do
    Nomination
    |> Repo.get_by!(document_id: document.id, id: id)
    |> Repo.preload(team_member: [:person, :team])
  end

  @doc """
  Creates a nomination.

  ## Examples

      iex> create_nomination(%{field: value})
      {:ok, %Nomination{}}

      iex> create_nomination(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nomination(document, team_member, attrs \\ %{}) do
    %Nomination{}
    |> Nomination.insert_changeset(attrs)
    |> Nomination.put_document(document)
    |> Nomination.put_team_member(team_member)
    |> Repo.insert()
  end

  @doc """
  Updates a nomination.

  ## Examples

      iex> update_nomination(nomination, %{field: new_value})
      {:ok, %Nomination{}}

      iex> update_nomination(nomination, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nomination(%Nomination{} = nomination, attrs) do
    nomination
    |> Nomination.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a nomination.

  ## Examples

      iex> delete_nomination(nomination)
      {:ok, %Nomination{}}

      iex> delete_nomination(nomination)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nomination(%Nomination{} = nomination) do
    Repo.delete(nomination)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nomination changes.

  ## Examples

      iex> change_nomination(nomination)
      %Ecto.Changeset{data: %Nomination{}}

  """
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
