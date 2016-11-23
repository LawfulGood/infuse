defmodule Simplate do
  require Logger

  @page_regex ~r/^\:page(?P<header>.*?)(\n|$)/m
  @page_split_regex ~r/():page()/
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
    {[once, every], templates} = parse_pages(contents) |> clean_pages() |> organize_pages()
    {_, once_bindings} = Code.eval_string(once.content)

    # Race condition

    %Simplate{
      file: file, 
      once: once,
      every: every,
      templates: recognize_templates(templates), 
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
  """
  def parse_pages(raw) do 
    #[pages] = Regex.split(@page_split_regex, raw, on: [1]) |> Enum.map(fn(p) -> parse_page(p) end)

    split_pages(raw) |> fill_blank_pages
  end

  defp fill_blank_pages(pages) do
    blank = [ %Page{} ] 

    case length(pages) do
      1 -> blank ++ blank ++ pages
      2 -> blank ++ pages
      _ -> pages
    end
  end

  defp split_pages(raw) do
    Regex.split(@page_split_regex, raw, on: [1]) |> Enum.map(fn(p) -> %Page{content: p} end)
  end

  defp recognize_templates(pages) do
    [Enum.reduce(pages, %{}, fn p, acc ->      
      {content_type, page} = parse_template(p)
      Map.put(acc, content_type, page) 
    end)]
  end

  #defp split_pages(raw) do
  #  [Enum.reduce(Regex.split(@page_split_regex, raw, on: [1]), %{}, fn p, acc ->      
  #    {content_type, page} = parse_page(p) 
  #    IO.inspect(content_type)
  #    Map.put(acc, content_type, page) 
  #  end)]
  #end]

  defp parse_template(page) do
    split = String.split(page.content, "\n")
    {renderer, content_type} = parse_specline(hd(split))

    {content_type, %Page{content: split, renderer: renderer, content_type: content_type}}
  end

  @doc """
  Returns a tuple `{[once, every], templates}`
  """
  defp organize_pages(pages) do
    code = Enum.take(pages, 2)
    templates = tl(tl(pages))

    {code, templates}
  end

  @doc """
  Removes any `:page` from the pages  
  """
  defp clean_pages(pages) do
    Enum.map(pages, fn(page) ->
      Map.put(page, "content", [tl(Regex.split(@page_regex, page.content))])
      page
    end)
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
