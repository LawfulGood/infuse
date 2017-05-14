defmodule Infuse do
  use Application
  require Logger

  def start(_type, _args) do
    :ets.new(:simplate_routes, [:named_table, :bag, :public])

    {:ok, pid} = Infuse.Supervisor.start_link
    
    if Infuse.config(:start_observer) do
      :observer.start()  
    end
    
    {:ok, pid}
  end

  def stop(_state) do
    :ok
  end

  def config(:web_root), do: Path.absname(Application.get_env(:infuse, :web_root, "www"))
  def config(:start_server), do: Application.get_env(:infuse, :start_server, true)
  def config(:start_observer), do: Application.get_env(:infuse, :start_observer, false)
  def config(:default_content_type), do: Application.get_env(:infuse, :default_content_type, "text/plain")

end
