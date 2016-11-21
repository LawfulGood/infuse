defmodule Simplate do

  @page_regex ~r/^\[---+\](?P<header>.*?)(\n|$)/m

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

  defp parse_page(raw_page) do
    %Page{content: raw_page}
  end

end