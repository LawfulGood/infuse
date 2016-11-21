defmodule Infuse.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Infuse.Router, [], [port: 8101])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
