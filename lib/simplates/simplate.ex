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
    {_, once_bindings} = Code.eval_string(once.content)

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
    render(simplate, Application.get_env(:infuse, :default_content_type))
  end

  def render(simplate, content_type) do
    {_, bindings} = Code.eval_string(simplate.every.content, simplate.once_bindings)

    template = simplate.templates["#{content_type}"]

    ren = Module.concat(["Infuse","Simplates","Renderers", template.renderer <> "Renderer"])
    ren.render(template.content, bindings)
  end

  def determine_routes(nil) do
    nil
  end

  def determine_routes(path) do
    [path |> String.replace(".spt", "") |> String.replace("index", "")]
  end

end
