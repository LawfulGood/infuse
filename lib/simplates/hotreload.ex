defmodule Infuse.Simplates.Hotreload do
  require Logger

  @name Infuse.Simplates.Hotreload

  def start_link() do
    Logger.info("Worker: Started Infuse.Simplates.Hotreload")

    :fs.start_link(:simplate_watcher, Infuse.config_web_root)
    :fs.subscribe(:simplate_watcher)
    
    loop()
  end 

  def loop() do
    receive do
      {_watcher_process, {:fs, :file_event}, {changedFile, [:modified]}} ->
        {:ok, simplate} = Infuse.Simplates.Registry.get(to_string(changedFile))
        #Simplates.Simplate.reload(simplate)
        loop()
    end
  end

end
