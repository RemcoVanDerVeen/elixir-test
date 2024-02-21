defmodule ElixirTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirTestWeb.Telemetry,
      ElixirTest.Repo,
      {DNSCluster, query: Application.get_env(:elixir_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirTest.Finch},
      # Start a worker by calling: ElixirTest.Worker.start_link(arg)
      # {ElixirTest.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
