defmodule Dutchpay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Dutchpay.Repo,
      {DNSCluster, query: Application.get_env(:dutchpay, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dutchpay.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dutchpay.Finch}
      # Start a worker by calling: Dutchpay.Worker.start_link(arg)
      # {Dutchpay.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Dutchpay.Supervisor)
  end
end
