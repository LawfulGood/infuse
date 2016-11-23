defmodule Simplate do
  require Logger

  #@page_regex ~r/^\:page(?P<header>.*?)(\n|$)/m
  @page_regex ~r/():page()/
  @specline_regex ~r/(?:\s+|^)via\s+/
  @renderer_regex ~r/via\s+(\w+)/

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
    {[once, every], templates} = parse_pages(contents) |> organize_pages()
    {_, once_bindings} = Code.eval_string(once.content)

    %Simplate{
      file: file, 
      once: once,
      every: every,
      templates: hd(templates), 
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

    EEx.eval_string(template.content, bindings)
  end

  @doc """
  If there's one page, it's a template.
  If there's more than one page, the first page is always code and the last is always a template.
  If there's more than two pages, the second page is code *unless it has a specline*, which makes it a template

  Returns a tuple `{[once, every], templates}`
  """
  def parse_pages(raw) do
    pages = [Enum.reduce(Regex.split(@page_regex, raw, on: [1]), %{}, fn p, acc ->
      {content_type, page} = parse_page(p) 
      Map.put(acc, content_type, page) 
    end)]
    #[pages] = Regex.split(@page_regex, raw, on: [1]) |> Enum.map(fn(p) -> parse_page(p) end)
    blank = [ %Page{} ] 

    case length(pages) do
      1 -> blank ++ blank ++ pages
      2 -> blank ++ pages
      _ -> pages
    end
  end

  defp parse_page(raw_page) do
    head = hd(String.split(raw_page, "\n"))

    {renderer, content_type} = parse_specline(head)

    {content_type, %Page{content: raw_page, renderer: renderer, content_type: content_type}}
  end

  defp organize_pages(pages) do
    code = Enum.take(pages, 2)
    templates = tl(tl(pages))

    {code, templates}
  end

  @doc """
  Parses a specline like `media/type via EEx` into a tuple {renderer, content_type}
  """
  def parse_specline(line) do
    case Regex.match?(@specline_regex, line) do
      true -> Regex.split(@specline_regex, line) |> do_parse_specline
      false -> do_parse_specline
    end
  end

  defp do_parse_specline([content_type, renderer]) do
    {String.trim(renderer), String.trim(content_type)}
  end

  defp do_parse_specline([strand]) do
    strand = String.trim(strand)
    case Regex.match?(@renderer_regex, strand) do
      true -> {strand, Application.get_env(:infuse, :default_content_type)}
      false -> {Application.get_env(:infuse, :default_renderer), strand}
    end
  end

  defp do_parse_specline do
    {Application.get_env(:infuse, :default_renderer), Application.get_env(:infuse, :default_content_type)}
  end

end
