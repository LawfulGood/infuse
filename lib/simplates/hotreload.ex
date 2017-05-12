defmodule Infuse.Simplates.Hotreload do
  require Logger

  def start_link() do
    Logger.info("Worker: Started Infuse.Simplates.Hotreload")
    Logger.info("Hotreload: Watching " <> Infuse.config(:web_root))

    :fs.start_link(:simplate_watcher, Infuse.config(:web_root))
    :fs.subscribe(:simplate_watcher)
    
    loop()
  end 

  def loop() do
    receive do
      {_watcher_process, {:fs, :file_event}, {changedFile, [:modified]}} ->
        IO.puts("Hotreload: #{changedFile} was updated")
        Infuse.Simplates.Loader.load(to_string(changedFile))
        loop()
    end
  end

end
