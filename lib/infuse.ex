defmodule Infuse do
  @moduledoc """
  Welcome to the documentation for Elixir!

  If you're viewing these docs from hexdocs.pm, you'll want to look at the sidebar to get around.
  """

  use Application
  require Logger

  @doc false
  def start(_type, _args) do
    :ets.new(:simplate_routes, [:named_table, :bag, :public])

    {:ok, pid} = Infuse.Supervisor.start_link
    
    if Infuse.config(:start_observer) do
      :observer.start()  
    end
    
    {:ok, pid}
  end

  @doc false
  def stop(_state) do
    :ok
  end

  @doc false
  def config(:web_root), do: Path.absname(Application.get_env(:infuse, :web_root, "www"))
  @doc false
  def config(:start_server), do: Application.get_env(:infuse, :start_server, true)
  @doc false
  def config(:start_observer), do: Application.get_env(:infuse, :start_observer, false)
  @doc false
  def config(:default_content_type), do: Application.get_env(:infuse, :default_content_type, "text/plain")
  @doc false
  def config(:default_indicies), do: Application.get_env(:infuse, :default_indicies, ["index.html", "index.json", "index", "index.html.spt", "index.json.spt", "index.spt"])

end
