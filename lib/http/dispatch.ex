defmodule Infuse.HTTP.Dispatch do

  def register(host, path, plug, opts) do
    true = :ets.insert(:simplate_routes, {host, path, plug, opts})
  end

  def unregister(host, path, plug) do
     true = :ets.match_delete(:simplate_routes, {host, path, plug, :_})
  end

  def init(tab) do 
    tab
  end

  def call(conn, _wat) do
    case :ets.match_object(:simplate_routes, {conn.host, conn.request_path, :_, :_}) do
      [{_host, _path, plug, opts}] -> plug.call(conn, plug.init(opts))
      [] -> Infuse.HTTP.Router.handle_notfound(conn)
    end
  end
  
end
