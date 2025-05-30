defmodule Examples.Util.Validators do
  import Ecto.Changeset

  def validate_assoc(changeset, name, validator) do
    relation = get_assoc(changeset, name, :struct)

    assoc_changeset =
      relation
      |> change()
      |> validator.()

    Enum.reduce(assoc_changeset.errors, changeset, fn
      {_field, {msg, opts}}, changeset ->
        add_error(changeset, :business_rule, msg, opts)
    end)
  end
end
