defmodule Nomify.DocumentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Nomify.Documents` context.
  """

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
end
