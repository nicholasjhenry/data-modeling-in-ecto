defmodule Examples.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :examples,
    adapter: Ecto.Adapters.Postgres
end
