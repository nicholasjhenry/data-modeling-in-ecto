defmodule Nomify.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Nomify.Repo,
      {DNSCluster, query: Application.get_env(:nomify, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Nomify.PubSub}
      # Start a worker by calling: Nomify.Worker.start_link(arg)
      # {Nomify.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Nomify.Supervisor)
  end
end
