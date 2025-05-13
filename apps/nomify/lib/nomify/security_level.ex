defmodule Nomify.SecurityLevel do
  @moduledoc """
  A security level is a classification that represents the degree of sensitivity
  or confidentiality associated with a resource or information.
  """

  @security_levels %{
    0 => :low,
    1 => :medium,
    2 => :high,
    3 => :secret
  }

  @type t :: :low | :medium | :high | :secret

  @doc false
  def values do
    Map.values(@security_levels)
  end

  @doc false
  def compare(security_level1, security_level2) do
    ranked_security_levels = switch_key_value(@security_levels)

    rank1 = Map.fetch!(ranked_security_levels, security_level1)
    rank2 = Map.fetch!(ranked_security_levels, security_level2)

    cond do
      rank1 == rank2 -> :eq
      rank1 > rank2 -> :gt
      rank1 < rank2 -> :lt
    end
  end

  defp switch_key_value(map) do
    map
    |> Enum.map(fn {key, value} -> {value, key} end)
    |> Map.new()
  end
end
