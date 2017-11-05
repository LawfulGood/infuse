defmodule Infuse.Simplates.Hotreload do
  use GenServer

  require Logger

  def start_link(web_root) do
    GenServer.start_link(__MODULE__, web_root)
  end

  def init(web_root) do
    Logger.info("Worker: Started Infuse.Simplates.Hotreload")

    {:ok, watcher_pid} = FileSystem.start_link(dirs: [web_root])
    FileSystem.subscribe(watcher_pid)

    Logger.info("Worker: Started watch on " <> web_root)
    
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, _events}}, %{watcher_pid: watcher_pid}=state) do
    Logger.info("Hotreload: #{path} was updated")
    Infuse.Simplates.Loader.load(to_string(path))

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid}=state) do

    {:noreply, state}
  end
end
