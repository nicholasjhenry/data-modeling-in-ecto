defmodule Nomify.DocumentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Documents` context.
  """

  import Nomify.TeamsFixtures

  @doc """
  Generate a document.
  """
  def document_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        publication_date: ~D[2025-04-15],
        security_level: :low,
        title: "some title"
      })

    {:ok, document} = Nomify.Documents.create_document(scope, attrs)

    document
  end

  def nominate_document(scope, document) do
    team_member =
      scope
      |> team_member_fixture()
      |> update_team_member_privilege(:nominate)

    {:ok, _nomination} =
      Nomify.Documents.nominate_document(scope, document, team_member, %{comments: "some comment"})

    Nomify.Documents.get_document!(document.id)
  end

  def approve_document(scope, document) do
    team_member =
      scope
      |> team_member_fixture()
      |> update_team_member_privilege(:nominate)

    {:ok, nomination} =
      Nomify.Documents.nominate_document(scope, document, team_member, %{comments: "some comment"})

    {:ok, nomination} =
      Nomify.Documents.update_nomination(scope, nomination, %{status: :in_review})

    {:ok, _nomination} =
      Nomify.Documents.update_nomination(scope, nomination, %{status: :approved})

    # Reload with new nominations
    Nomify.Documents.get_document!(document.id)
  end

  @doc """
  Generate a nomination.
  """
  def nomination_fixture(scope, attrs \\ %{}, assocs \\ %{}) do
    assocs = Map.new(assocs)
    document = Map.get_lazy(assocs, :document, fn -> document_fixture(scope) end)

    team_member =
      Map.get_lazy(assocs, :team_member, fn ->
        scope |> team_member_fixture() |> update_team_member_privilege(:nominate)
      end)

    attrs =
      Enum.into(attrs, %{
        comments: "some comments",
        nomination_date: ~D[2025-04-15],
        status: :pending
      })

    {:ok, nomination} = Nomify.Documents.nominate_document(scope, document, team_member, attrs)

    nomination
  end
end
