defmodule MaddenDraft.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MaddenDraft.Worker.start_link(arg)
      # {MaddenDraft.Worker, arg}
      MaddenDraft.Boundary.PlayerManager
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MaddenDraft.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
