defmodule Simplate do
  
  def parse do
    #[once, every, template] = 

    #{_, once_bindings} = Code.eval_string(once)
    #{_, bindings} = Code.eval_string(every, once_bindings)

    #EEx.eval_string(template, bindings)
  end

  @doc """
  If there's one page, it's a template.
  If there's more than one page, the first page is always code and the last is always a template.
  If there's more than two pages, the second page is code *unless it has a specline*, which makes it a template
  """
  def parse_pages(raw) do
    pages = Regex.split(~r/^\[---+\](?P<header>.*?)(\n|$)/m, raw, include_captures: true) |> Enum.map(fn(p) -> parse_page(p) end)
    blank = [ %Page{} ] 

    case length(pages) do
      1 -> blank ++ blank ++ pages
      2 -> blank ++ pages
    end
  end

  defp parse_page(raw_page) do
    %Page{content: raw_page}
  end

end