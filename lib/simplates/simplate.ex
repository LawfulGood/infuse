defmodule Simplate do

  @page_regex ~r/^\:page(?P<header>.*?)(\n|$)/m
  @specline_regex ~r/(?:\s+|^)via\s+/
  @renderer_regex ~r/via\s+(\w+)/

  defstruct file: nil, pages: [], once_bindings: nil  
  
  def load(file) do
    {:ok, body} = File.read(file)

    pages = parse_pages(body)
    {_, once_bindings} = Code.eval_string(hd(pages).content)

    %Simplate{file: file, pages: pages, once_bindings: once_bindings}
  end

  def render(simplate) do
    [once, every, template] = simplate.pages
    {_, once_bindings} = Code.eval_string(once.content)
    {_, bindings} = Code.eval_string(every.content, once_bindings)

    EEx.eval_string(template.content, bindings)
  end

  @doc """
  If there's one page, it's a template.
  If there's more than one page, the first page is always code and the last is always a template.
  If there's more than two pages, the second page is code *unless it has a specline*, which makes it a template
  """
  def parse_pages(raw) do
    pages = Regex.split(@page_regex, raw) |> Enum.map(fn(p) -> parse_page(p) end)
    blank = [ %Page{} ] 

    case length(pages) do
      1 -> blank ++ blank ++ pages
      2 -> blank ++ pages
      3 -> pages
    end
  end

  @doc """
  Parses a specline like `media/type via EEx` into a tuple {renderer, content_type}
  """
  def parse_specline(line) do
    Regex.split(@specline_regex, line) |> do_parse_specline
  end

  defp do_parse_specline([content_type, renderer]) do
    {renderer, content_type}
  end

  defp do_parse_specline([strand]) do
    case Regex.match?(@renderer_regex, strand) do
      true -> {strand, ""}
      false -> {"", strand}
    end
  end

  defp parse_page(raw_page) do
    %Page{content: raw_page}
  end

end