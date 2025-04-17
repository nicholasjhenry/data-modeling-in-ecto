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

  @doc """
  Generate a nomination.
  """
  def nomination_fixture(
        attrs \\ %{},
        document \\ document_fixture(),
        team_member \\ team_member_fixture()
      ) do
    attrs =
      Enum.into(attrs, %{
        comments: "some comments",
        nomination_date: ~D[2025-04-15],
        status: :pending
      })

    {:ok, nomination} = Nomify.Documents.create_nomination(document, team_member, attrs)

    nomination
  end
end
