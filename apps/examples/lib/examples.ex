defmodule Examples do
  @moduledoc """
  Documentation for `Examples`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Examples.hello()
      :world

  """
  def hello do
    :world
  end

  @doc false
  def record do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query, warn: false

      def validate_assoc(changeset, name, validator) do
        relation = get_assoc(changeset, name, :struct)

        assoc_changeset =
          relation
          |> change()
          |> validator.()

        put_change(changeset, name, assoc_changeset)
      end
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
