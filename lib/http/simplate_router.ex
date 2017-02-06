defmodule Infuse.HTTP.SimplateRouter do
  @moduledoc """
  Registers/Handles Simplate Routes to the ETS table

  The module determines if the Simplate has a matching route and 
  dispatches it to Infuse.HTTP.SimplateDispatch
  """

  import Plug.Conn

  def init(options) do
    
    options
  end

  def call(conn, _opts) do
    case :ets.match_object(:simplate_routes, {conn.request_path, :_, :_}) do
      [{_path, plug, opts}] -> plug.call(conn, plug.init(opts))
      [] -> conn
    end
  end

  @doc """
  Register a route with the SimplateRouter
  """
  def register(path, plug, opts) do
    true = :ets.insert(:simplate_routes, {path, plug, opts})
  end

  @doc """
  Unregister a route with the SimplateRouter
  """
  def unregister(path, plug) do
     true = :ets.match_delete(:simplate_routes, {path, plug, :_})
  end

end
