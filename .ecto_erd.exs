alias Ecto.ERD.Node

map_node_fn = fn
  # Exclude the following schemas
  %Node{schema_module: schema_module}
  when schema_module in [Ecto.Migration.SchemaMigration, Flop, Flop.Filter, Oban.Job] ->
    nil

  # Only include table-backed schemas
  %Node{schema_module: schema_module, source: source} = node when not is_nil(source) ->
    case Module.split(schema_module) do
      [_] -> node
      [namespace, _] -> node |> Node.set_cluster(namespace)
      parts -> node |> Node.set_cluster(parts |> Enum.take(2) |> Enum.join("."))
    end

  _node ->
    nil
end

[
  otp_app: :nomify,
  map_node: map_node_fn
]
