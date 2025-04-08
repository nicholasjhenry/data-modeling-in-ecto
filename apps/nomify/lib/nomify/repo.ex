defmodule Nomify.Repo do
  use Ecto.Repo,
    otp_app: :nomify,
    adapter: Ecto.Adapters.Postgres
end
