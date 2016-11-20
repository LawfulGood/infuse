defmodule Simplate do
  
  def render(file) do
    {:ok, body} = File.read(file)


    [once, every, template] = parse_pages(body)
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
    pages = Regex.split(~r/^\[---+\](?P<header>.*?)(\n|$)/m, raw) |> Enum.map(fn(p) -> parse_page(p) end)
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