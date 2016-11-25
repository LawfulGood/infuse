defmodule Infuse do
  use Application

  def start(_type, _args) do
    Infuse.Supervisor.start_link
  end

  def autoload(dir) do
    DirWalker.stream(dir) |> Enum.map(fn(v) -> 
      Infuse.Simplates.Registry.put(v, Simplate.load_file(v)) 
    end)
  end

end
