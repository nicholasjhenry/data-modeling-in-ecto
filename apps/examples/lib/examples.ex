defmodule Examples do
  @moduledoc """
  Examples based on SOM, Chapter 4, Collaboration Rules and Chapter 8, Implementing Business Rules.
  """

  @doc false
  def record do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query, warn: false

      import Examples.Util.Validators
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
