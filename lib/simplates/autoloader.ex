defmodule Infuse.Simplates.Autoloader do
  require Logger

  @name Infuse.Simplates.Autoloader

  def start_link(web_root) do
    Logger.info("Worker: Started Infuse.Simplates.Autoloader")

    autoload(web_root)

    {:ok, self()}
  end 

  @doc """
  Traverse the Simplates directory and load each file & register routes
  """
  def autoload(dir) do
    Enum.map(Path.wildcard(Path.join([dir, "**", "*.spt"])), fn(v) -> 
      name = String.replace(v, Infuse.config_web_root(), "") # Remove webroot from path
      {:ok, simplate} = Simplate.load_file(v, name)
       
      # Register the routes!
      Enum.map(simplate.routes, fn(route) -> 
        Infuse.HTTP.SimplateRouter.register(route, Infuse.HTTP.SimplateDispatch, %{:simplate => simplate})
        Logger.info("Dispatch: Registering #{route}")
      end)
      
    end)
  end

end
