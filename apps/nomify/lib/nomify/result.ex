defmodule Nomify.Result do
  def put_result(:ok, changeset, _key) do
    changeset
  end

  def put_result({:error, message}, changeset, key) do
    Ecto.Changeset.add_error(changeset, key, message)
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
