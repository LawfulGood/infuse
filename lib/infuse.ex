defmodule Infuse do
  use Application
  require Logger

  def start(_type, _args) do
    :ets.new(:simplate_routes, [:named_table, :bag, :public])

    {:ok, pid} = Infuse.Supervisor.start_link
    
    if Infuse.config_start_observer() do
      :observer.start()  
    end
    
    {:ok, pid}
  end

  def stop(_state) do
    :ok
  end

  def config(:web_root), do: Path.absname(Application.get_env(:infuse, :web_root) || "www")
  def config(:start_server), do: Application.get_env(:infuse, :start_server)
  def config(:start_observer), do: Application.get_env(:infuse, :start_observer)

  @doc """
  Returns a usable webroot
  """
  def config_web_root do
    Path.absname(Application.get_env(:infuse, :web_root) || "www")
  end

  @doc """
  Should the server autostart 
  """
  def config_start_server do
    Application.get_env(:infuse, :start_server)
  end

  @doc """
  Autostart observer for debugging
  """
  def config_start_observer do
    Application.get_env(:infuse, :start_observer)
  end

end
