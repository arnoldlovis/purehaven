defmodule Purehaven.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PurehavenWeb.Telemetry,
      Purehaven.Repo,
      {DNSCluster, query: Application.get_env(:purehaven, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Purehaven.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Purehaven.Finch},
      # Start a worker by calling: Purehaven.Worker.start_link(arg)
      # {Purehaven.Worker, arg},
      # Start to serve requests, typically the last entry
      PurehavenWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Purehaven.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PurehavenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
