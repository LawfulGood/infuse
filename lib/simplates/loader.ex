defmodule Infuse.Simplates.Loader do
  require Logger

  alias Simplates.Simplate, as: Simplate

  def start_link(web_root) do
    Logger.info("Worker: Started Infuse.Simplates.Loader")

    autoload(web_root)

    {:ok, self()}
  end 

  @doc """
  Traverse the Simplates directory and load each file & register routes
  """
  def autoload(dir) do
    Enum.map(Path.wildcard(Path.join([dir, "**", "*.spt"])), fn(v) -> 
      load(v)      
    end)
  end

  def load(path) do
    simplate = Simplate.create_from_file(path)

    routes = simplate.filepath |> remove_webroot() |> determine_routes()

    # Register the routes!
    Enum.map(routes, fn(route) -> 
      Infuse.HTTP.SimplateRouter.unregister(route, Infuse.HTTP.SimplateDispatch)
      Infuse.HTTP.SimplateRouter.register(route, Infuse.HTTP.SimplateDispatch, %{:simplate => simplate})
      Logger.info("Dispatch: Registering #{route}")
    end)
  end

  def remove_webroot(fs_path) do
    String.replace(fs_path, Infuse.config(:web_root), "")
  end

  @doc """
  
  """
  def determine_routes(rel_path) do
    # Exact match routes, eg: index.html => index.html

    # Bound Simplate routes, eg: index.html.spt => index.html

    # Unbound Simplate routes, eg: index.spt => [index.json, index.xml]

    [rel_path 
      |> String.replace(".spt", "") 
      |> String.replace(".html", "") 
      |> String.replace("index", "")]
  end

end
