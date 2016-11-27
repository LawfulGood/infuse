defmodule Infuse.Simplates.Pagination do

  @page_split_regex ~r/()\[---+\]()/

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
    Regex.split(@page_split_regex, raw, on: [1]) |> Enum.map(fn(p) -> 
      do_page(p)
    end)
  end

  defp do_page(raw) do
    raw = Regex.replace(@page_split_regex, raw, "")
    split = String.split(raw, "\n")
    first_line = String.trim(hd(split))
    {status, renderer, content_type} = Infuse.Simplates.Specline.parse_specline(first_line)

    page_content = 
      case status do
        :ok -> tl(split) |> Enum.join(" ") |> String.trim()
        :empty -> raw |> String.trim()
      end

    %Page{
      content: page_content, 
      compiled: renderer.compile(page_content),
      renderer: renderer, 
      content_type: content_type}
  end

  @doc """
  Organize simplates templates into their associated mime types
  """
  def organize_templates(pages) do
    Enum.reduce(pages, %{}, fn page, acc ->
      Map.put(acc, page.content_type, page) 
    end)
  end

  @doc """
  Organize pages into code and templates. 
  """
  def organize_pages(pages) do
    code = Enum.take(pages, 2)
    templates = tl(tl(pages))

    {code, templates}
  end
    
end
