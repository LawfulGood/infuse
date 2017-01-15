defmodule Infuse.HTTP.SimplateRouter do
  @moduledoc """
  Handles the custom Plug router's simplate call
  """
  
  def init(opts) do
    opts
  end

  def call(conn, opts) do    
    simplate = Infuse.Simplates.Registry.get(opts.simplate.file)
    body = Simplate.render(simplate)
    
    Plug.Conn.send_resp(conn, 200, body)
  end

end