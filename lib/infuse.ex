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
      simplate = Simplate.load_file(v, name)
      Infuse.Simplates.Registry.put(name, simplate)
       
      # Register the routes!
      Enum.map(simplate.routes, fn(route) -> 
        Infuse.HTTP.Dispatch.register("localhost", route, Infuse.HTTP.SimplateRouter, %{:simplate => simplate})
        Logger.info("DISPATCH: Registering #{route}")
      end)

      
    end)
  end

end
