defmodule Infuse.HTTP.SimplatePlug do
  import Plug.Conn

  def init(options) do
    
    options
  end

  def call(conn, _opts) do
    case :ets.match_object(:simplate_routes, {conn.host, conn.request_path, :_, :_}) do
      [{_host, _path, plug, opts}] -> plug.call(conn, plug.init(opts))
      [] -> conn
    end
  end
end
