defmodule Simplate do
  require Logger

  defstruct file: nil, routes: nil, once: nil, every: nil, templates: {}, once_bindings: nil  
  
  @doc """
  Opens a simplate, sends to load
  """
  def load_file(file, partial_path \\ nil) do
    Logger.info("Simplate: Loading " <> file)
    {:ok, body} = File.read(file)

    load(body, partial_path)
  end

  @doc """
  Takes contents, executes the first page and quotes the second page for later
  """
  def load(contents, file \\ nil) do
    {[once, every], templates} = Infuse.Simplates.Pagination.parse_pages(contents) |> Infuse.Simplates.Pagination.organize_pages()

    # Gotta redo this for now, should be moved
    once = %{once | renderer: Infuse.Simplates.Renderers.CodeRenderer, compiled: Infuse.Simplates.Renderers.CodeRenderer.compile(once.content)}
    every = %{every | renderer: Infuse.Simplates.Renderers.CodeRenderer, compiled: Infuse.Simplates.Renderers.CodeRenderer.compile(every.content)}

    {_, once_bindings} = once.renderer.render(once.compiled)

    routes = determine_routes(file)

    # Race condition

    %Simplate{
      file: file,
      routes: routes, 
      once: once,
      every: every,
      templates: Infuse.Simplates.Pagination.organize_templates(templates), 
      once_bindings: once_bindings
    }
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

end
