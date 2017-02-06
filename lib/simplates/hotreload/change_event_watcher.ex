defmodule Infuse.Simplates.Hotreload.ChangeEventWatcher do
  
  def start_link(manager) do
    GenServer.start_link(__MODULE__, manager, [])
  end

  def init(manager) do
    :ok = GenEvent.add_mon_handler(manager, Infuse.Simplates.Hotreload.ChangeEvent, self())

    {:ok, manager}
  end

end
