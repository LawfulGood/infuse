defmodule Infuse do
  use Application

  def start(_type, _args) do
    if Mix.env == :dev do
      Infuse.Simplates.Registry.start_link
      autoload(Application.get_env(:infuse, :web_root))
    end

    Infuse.Supervisor.start_link
  end

  def autoload(dir) do
    DirWalker.stream(dir) |> Enum.map(fn(v) -> 
      name = String.replace(v, Application.get_env(:infuse, :web_root) <> "/", "") # Remove webroot from path
      Infuse.Simplates.Registry.put(name, Simplate.load_file(v)) 
    end)
  end

end
