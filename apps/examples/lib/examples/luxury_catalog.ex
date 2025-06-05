defmodule Examples.LuxuryCatalog do
  @moduledoc """
  The LuxuryCatalog context.
  """

  import Ecto.Query, warn: false
  alias Examples.Repo

  alias Examples.LuxuryCatalog.Category

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end
end
