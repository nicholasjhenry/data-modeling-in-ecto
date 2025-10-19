defmodule Nomify.Util.UnicodeIdentifier do
  @valid_categories [
    # Letters
    :Lu,
    :Ll,
    :Lt,
    :Lm,
    :Lo,
    # Marks
    :Mn,
    :Mc,
    # Numbers
    :Nd,
    # Connector punctuation
    :Pc
  ]

  def unicode_identifier_part?(char) do
    [category] = Unicode.GeneralCategory.category(char)
    category in @valid_categories
  end
end
