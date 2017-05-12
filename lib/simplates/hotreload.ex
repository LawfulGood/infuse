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
        Logger.info("Hotreload: #{changedFile} was updated")

        IO.inspect(File.stat!("#{changedFile}"))
        
        # handle potential bug in inotify
        if File.stat!("#{changedFile}").size > 0 do
          Infuse.Simplates.Loader.load(to_string(changedFile))
        end

        loop()
    end
  end

end
