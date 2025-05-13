defmodule Nomify.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :nomify,
    adapter: Ecto.Adapters.Postgres
end
