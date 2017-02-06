defmodule Simplate do
  require Logger

  defstruct fs_path: nil, web_path: nil, routes: nil, once: nil, every: nil, templates: {}, once_bindings: nil  
  
  @doc """
  Opens a simplate, sends to load
  """
  def load_file(file, partial_path \\ nil) do
    file = Path.absname(file)
    rel_file = rel_path(file)
    Logger.info("Simplate: Loading #{file} as #{rel_file}")
    {:ok, body} = File.read(file)

    simplate = load(body, file, partial_path)
    Infuse.Simplates.Registry.put(rel_file, simplate)

    {:ok, simplate}
  end

  @doc """
  Takes contents, executes the first page and quotes the second page for later
  """
  def load(contents, fs_path \\ nil, web_path \\ nil) do
    {[once, every], templates} = Infuse.Simplates.Pagination.parse_pages(contents) |> Infuse.Simplates.Pagination.organize_pages()

    # Gotta redo this for now, should be moved
    once = %{once | renderer: Infuse.Simplates.Renderers.CodeRenderer, compiled: Infuse.Simplates.Renderers.CodeRenderer.compile(once.content)}
    every = %{every | renderer: Infuse.Simplates.Renderers.CodeRenderer, compiled: Infuse.Simplates.Renderers.CodeRenderer.compile(every.content)}

    {_, once_bindings} = once.renderer.render(once.compiled)

    routes = determine_routes(web_path)

    # Race condition

    %Simplate{
      fs_path: fs_path,
      web_path: web_path,
      routes: routes, 
      once: once,
      every: every,
      templates: Infuse.Simplates.Pagination.organize_templates(templates), 
      once_bindings: once_bindings
    }
  end

  def find_by_fullpath(path) do
    case String.replace(path, Infuse.config_web_root(), "") |> Infuse.Simplates.Registry.get() do
      simplate = %Simplate{} -> 
        {:ok, simplate}
      nil ->
        {:error, :enoent}
    end
  end

  def get(simplate_path) do
    simplate = Infuse.Simplates.Registry.get(simplate_path)
    {:ok, simplate}
  end

  def reload(simplate) do
    Logger.info("Simplate: Reloading " <> simplate.fs_path)
    load_file(simplate.fs_path)
  end

  @doc """
  Render a simplate, returning the output, will eventually be moved.
  """
  def render(simplate) do
    render(simplate, default_content_type())
  end

  def render(simplate, content_type) do
    {_, bindings} = Infuse.Simplates.Renderers.CodeRenderer.render(simplate.every.compiled, simplate.once_bindings)

    template = simplate.templates["#{content_type}"]

    template.renderer.render(template.compiled, bindings)
  end

  def determine_routes(nil) do
    nil
  end

  def determine_routes(path) do
    [path |> String.replace(".spt", "") |> String.replace("index", "")]
  end

  @doc """
  Returns a default content type set by config or app  
  """
  def default_content_type do
    Application.get_env(:infuse, :default_content_type) || "text/html"
  end

  @doc """
  Returns a default renderer set by config or app  
  """
  def default_renderer do
    Application.get_env(:infuse, :default_renderer) || Infuse.Simplates.Renderers.EExRenderer
  end

  defp rel_path(full_path) do
    String.replace(full_path, Infuse.config_web_root(), "")
  end

end
