defmodule EssentialEcto do
  import Ecto.Changeset

  def delete_assoc(parent_changeset, name, value) do
    child_changeset = %{change(value) | action: :delete}

    children =
      parent_changeset
      |> get_assoc(name, :struct)
      |> Enum.reject(&(&1.id == value.id))

    put_assoc(parent_changeset, name, [child_changeset | children])
  end

  def get_all_assocs(changeset, name, :insert_or_update) do
    changeset
    |> get_assoc(name)
    |> Enum.reject(fn maybe_child_changeset ->
      match?(%Ecto.Changeset{}, maybe_child_changeset) and maybe_child_changeset.action == :delete
    end)
  end
end
