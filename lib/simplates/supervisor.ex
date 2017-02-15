defmodule Infuse.Simplates.Supervisor do
  use Supervisor

  require Logger

  @name Infuse.Simplates.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(Infuse.Simplates.Registry, []),
      worker(Infuse.Simplates.Loader, [Infuse.config(:web_root)]),
      #worker(Task, [fn -> Infuse.Simplates.Hotreload.start_link end]),
    ]

    Logger.info("Supervisor: Started Infuse.Simplates.Supervisor")

    supervise(children, strategy: :one_for_all)
  end

end
