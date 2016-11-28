defmodule Infuse do
  use Application
  require Logger

  def start(_type, _args) do
    if Mix.env == :dev do
      :ets.new(:simplate_routes, [:named_table, :bag, :public])
      Infuse.Simplates.Registry.start_link
      autoload(Application.get_env(:infuse, :web_root))
    end

    Infuse.Supervisor.start_link
  end

  def autoload(dir) do
    DirWalker.stream(dir) |> Enum.map(fn(v) -> 
      name = String.replace(v, Application.get_env(:infuse, :web_root), "") # Remove webroot from path
      Infuse.Simplates.Registry.put(name, Simplate.load_file(v)) 

      Infuse.HTTP.Dispatch.register("localhost", name, Infuse.HTTP.SimplateRouter, :handle_simplate)
      Logger.info("DISPATCH: Registering #{name}")
    end)
  end

end
