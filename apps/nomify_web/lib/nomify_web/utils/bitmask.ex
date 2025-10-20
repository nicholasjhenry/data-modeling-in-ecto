defimpl Phoenix.HTML.Safe, for: Bitmask do
  def to_iodata(bitmask) do
    Enum.map_join(bitmask.flags, ", ", &to_string(&1))
  end
end
