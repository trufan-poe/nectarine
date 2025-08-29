defmodule Nectarine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NectarineWeb.Telemetry,
      Nectarine.Repo,
      {DNSCluster, query: Application.get_env(:nectarine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Nectarine.PubSub},
      # Start a worker by calling: Nectarine.Worker.start_link(arg)
      # {Nectarine.Worker, arg},
      # Start to serve requests, typically the last entry
      NectarineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nectarine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NectarineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
