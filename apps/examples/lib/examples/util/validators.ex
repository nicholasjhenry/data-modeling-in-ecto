defmodule Examples.Util.Validators do
  import Ecto.Changeset

  def validate_assoc(changeset, name, validator) do
    %{} = relation = get_assoc(changeset, name, :struct)

    validator.(relation, changeset)
  end
end
