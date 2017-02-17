defmodule Infuse.Supervisor do
  use Supervisor

  require Logger

  @name Infuse.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    base_children = [
      supervisor(Infuse.Simplates.Supervisor, [])
    ]

    children =
      case Infuse.config(:start_server) do
        true -> 
          Logger.info("Started Infuse Server on 8101")
          base_children ++ [Plug.Adapters.Cowboy.child_spec(:http, Infuse.HTTP.Pipeline, [], [port: 8101])]
        false ->
          base_children
      end

    Logger.info("Supervisor: Started Infuse.Supervisor")

    supervise(children, strategy: :one_for_one)
  end
end
