defmodule Infuse.Simplates.Loader do
  @moduledoc """
  
    Exact match routes, eg: index.html => index.html
    Bound Simplate routes, eg: index.html.spt => index.html
    Unbound Simplate routes, eg: index.spt => [index.json, index.xml]

  """
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

    routes = determine_routes(simplate)

    Logger.info("Dispatch: Registering " <> clean_path(simplate.filepath) <> " to " <> Enum.join(routes, ", "))

    # Register the routes!
    Enum.map(routes, fn(route) -> 
      Infuse.HTTP.SimplateRouter.unregister(route, Infuse.HTTP.SimplateDispatch)
      Infuse.HTTP.SimplateRouter.register(route, Infuse.HTTP.SimplateDispatch, %{:simplate => simplate})
    end)
  end

  def remove_webroot(fs_path) do
    String.replace(fs_path, Infuse.config(:web_root), "")
  end

  defp clean_path(path) do
    path |> remove_webroot() |> String.replace(".spt", "")
  end

  def determine_routes(%Simplate{} = simplate) do
    replacement_route(simplate) ++ content_type_route(simplate) ++ directory_route(simplate) ++ wildcard_route(simplate)
  end

  defp replacement_route(%Simplate{} = simplate) do
    [simplate.filepath
      |> clean_path()
      |> String.replace(".html", "") 
      |> String.replace("index", "")]
  end

  defp content_type_route(%Simplate{} = simplate) do
    extensions = Enum.reduce(simplate.templates, [], fn({content_type, _} , acc) -> 
      acc ++ MIME.extensions(content_type)
    end)

    path = clean_path(simplate.filepath)

    routes = Enum.map(extensions, fn(ext) ->
      path <> "." <> ext
    end)

    has_extension = Regex.match?(~r/^.*\.[^\\]+$/, simplate.filepath)

    # don't generate extensions if filepath contains one
    routes = cond do
      has_extension == true -> []
      true -> routes
    end

    routes
  end

  defp directory_route(%Simplate{} = simplate) do
    routes = []

    default_indicies = Infuse.config(:default_indicies)
    file_name = Path.basename(simplate.filepath)

    routes = 
      case Enum.member?(default_indicies, file_name) do
        true -> [simplate.filepath |> clean_path() |> Path.rootname(), simplate.filepath |> clean_path()]
        false -> routes
      end

    routes
  end

  def wildcard_route(%Simplate{} = simplate) do
    routes = [simplate.wild_path |> clean_path()]

    IO.inspect(simplate.wild_path)

    routes
  end

end
