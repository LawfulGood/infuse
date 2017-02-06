defmodule Infuse.HTTP.SimplateDispatch do
  @moduledoc """
  Handle the Simplate HTTP Dispatch

  The Infuse.HTTP.SimplateRouter is used for determining if the simplate is 
  valid and sending it here
  """
  
  def init(opts) do
    opts
  end

  def call(conn, opts) do    
    simplate = Infuse.Simplates.Registry.get(opts.simplate.web_path)
    body = Simplate.render(simplate)
    
    conn 
    |> Plug.Conn.send_resp(200, body)
    |> Plug.Conn.halt()
  end

end
