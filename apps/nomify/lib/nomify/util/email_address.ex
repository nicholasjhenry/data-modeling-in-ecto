defmodule Nomify.Util.EmailAddress do
  # Ported from Streamlined Object Modeling

  @type t :: String.t()

  alias Nomify.Util.UnicodeIdentifier

  @spec parse(String.t()) :: {:ok, t()} | :error
  def parse(value) do
    with {:ok, value} <- string_required(value),
         {:ok, dot_pos} <- find_index(value, "."),
         {:ok, at_pos} <- find_index(value, "@"),
         last_pos <- String.length(value),
         # if '.' is last char then is invalid
         :ok <- validate_pos(last_pos, dot_pos),
         # if last '.' is before '@' or no character between them then is invalid
         :ok <- validate_pos(dot_pos, at_pos),
         # check pieces for invalid characters:
         # 1. from start up to last '@'
         :ok <- validate_piece(value, 0, at_pos),
         # 2. from after last '@' up to last '.'
         :ok <- validate_piece(value, at_pos + 1, dot_pos),
         # 3. from after last '.' to end
         :ok <- validate_piece(value, dot_pos + 1, last_pos + 1) do
      {:ok, value}
    else
      :error -> :error
    end
  end

  defp string_required(value) when is_binary(value) do
    value = String.trim(value)

    if value == "" do
      :error
    else
      {:ok, value}
    end
  end

  defp string_required(_value), do: :error

  defp find_index(value, char) do
    reverse_index =
      value
      |> String.split("", trim: true)
      |> Enum.reverse()
      |> Enum.find_index(&(&1 == char))

    if reverse_index do
      index = String.length(value) - reverse_index - 1
      {:ok, index}
    else
      :error
    end
  end

  defp validate_pos(start_pos, end_pos) do
    if start_pos < end_pos + 2 do
      :error
    else
      :ok
    end
  end

  # Checks if portion of email address is valid.
  # Portions checked fall before last '@' symbol,
  # between '@' and last '.' ,
  # and after last '.' to end of address.
  # Returns error if first character is not letter, digit, or, '_'.
  # Allows '.' and '_' in remainder of string.
  #
  defp validate_piece(value, start_pos, end_pos) do
    result =
      value
      |> String.slice(start_pos, end_pos - start_pos)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce_while(true, &validate_char/2)

    case result do
      :error -> :error
      true -> :ok
    end
  end

  defp validate_char({char, index}, _acc) do
    cond do
      index == 0 and !UnicodeIdentifier.unicode_identifier_part?(char) ->
        {:halt, :error}

      char in [".", "-", "_"] or UnicodeIdentifier.unicode_identifier_part?(char) ->
        {:cont, true}

      true ->
        {:halt, :error}
    end
  end
end
