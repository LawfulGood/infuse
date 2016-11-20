defmodule Aspen.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Aspen.Router, [], [port: 8101])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
