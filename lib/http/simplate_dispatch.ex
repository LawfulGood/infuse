defmodule Infuse.HTTP.SimplateDispatch do
  @moduledoc """
  Handle the Simplate HTTP Dispatch

  The Infuse.HTTP.SimplateRouter is used for determining if the simplate is 
  valid and sending it here
  """
  import Plug.Conn
  
  def init(opts) do
    opts
  end

  def call(pre_conn, opts) do
    simplate = opts.simplate
    #simplate = Infuse.Simplates.Registry.get(opts.simplate.web_path)

    pre_conn = pre_conn
                |> put_status(200)
                #|> put_resp_content_type(Simplate.default_content_type)

    content_type = "text/plain"

    #IO.inspect(Simplates.Simplate.render(simplate, content_type, [conn: pre_conn]))
    %{:output => output, :content_type => content_type} = 
      Simplates.Simplate.render(simplate, content_type, [conn: pre_conn])
    
    conn = pre_conn
    
    conn 
    |> put_resp_content_type(content_type)
    |> send_resp(conn.status, output)
    |> halt()
  end

end
