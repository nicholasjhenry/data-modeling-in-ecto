defmodule Nomify.SecurityLevel do
  @security_levels %{
    0 => :low,
    1 => :medium,
    2 => :high,
    3 => :secret
  }

  def values do
    Map.values(@security_levels)
  end

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
