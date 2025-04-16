defimpl Phoenix.HTML.Safe, for: Bitmask do
  def to_iodata(bitmask) do
    bitmask.flags
    |> Enum.map(&to_string(&1))
    |> Enum.join(", ")
  end
end
