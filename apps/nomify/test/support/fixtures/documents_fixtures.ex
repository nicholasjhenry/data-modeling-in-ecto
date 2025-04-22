defmodule Nomify.DocumentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Documents` context.
  """

  import Nomify.ResourcesFixtures

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{
        publication_date: ~D[2025-04-15],
        security_level: :low,
        title: "some title"
      })
      |> Nomify.Documents.create_document()

    document
  end

  def nominate_document(document) do
    team_member = team_member_fixture() |> update_team_member_privilege(:nominate)

    {:ok, _nomination} =
      Nomify.Documents.nominate_document(document, team_member, %{comments: "some comment"})

    Nomify.Documents.get_document!(document.id)
  end

  def approve_document(document) do
    team_member = team_member_fixture() |> update_team_member_privilege(:nominate)

    {:ok, nomination} =
      Nomify.Documents.nominate_document(document, team_member, %{comments: "some comment"})

    {:ok, nomination} = Nomify.Documents.update_nomination(nomination, %{status: :in_review})
    {:ok, _nomination} = Nomify.Documents.update_nomination(nomination, %{status: :approved})

    # Reload with new nominations
    Nomify.Documents.get_document!(document.id)
  end

  @doc """
  Generate a nomination.
  """
  def nomination_fixture(
        attrs \\ %{},
        document \\ document_fixture(),
        team_member \\ team_member_fixture() |> update_team_member_privilege(:nominate)
      ) do
    attrs =
      Enum.into(attrs, %{
        comments: "some comments",
        nomination_date: ~D[2025-04-15],
        status: :pending
      })

    {:ok, nomination} = Nomify.Documents.nominate_document(document, team_member, attrs)

    nomination
  end
end
