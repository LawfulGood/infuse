defmodule Infuse.Simplates.Autoloader do 

  def load_path(path) do
    {:ok, walker} = DirWalker.start_link(path)

    Enum.map(walker, fn(v) -> IO.puts(v) end)
  end

  defp load_file(file) do
    
  end

end