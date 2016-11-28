defmodule Simplate do
  require Logger

  defstruct file: nil, once: nil, every: nil, templates: {}, once_bindings: nil  
  
  @doc """
  Opens a simplate, sends to load
  """
  def load_file(file) do
    Logger.info("Simplate: Loading " <> file)
    {:ok, body} = File.read(file)

    load(body, file)
  end

  @doc """
  Takes contents, executes the first page and quotes the second page for later
  """
  def load(contents, file \\ nil) do
    {[once, every], templates} = Infuse.Simplates.Pagination.parse_pages(contents) |> Infuse.Simplates.Pagination.organize_pages()
    {_, once_bindings} = Code.eval_string(once.content)

    # Race condition

    %Simplate{
      file: file, 
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

end
