defmodule Infuse.HTTP.SimplateRouter do
  
  def init(opts) do
    opts
  end

  def call(conn, opts) do    
    simplate = Infuse.Simplates.Registry.get(opts.simplate.file)
    body = Simplate.render(simplate)
    Plug.Conn.send_resp(conn, 200, body)
  end

#  match "/*glob" do
#     raise "oops"
#
#    glob = case glob do
#      [] -> "index"
#      _ -> glob
#    end
#    
#    simplate = Infuse.Simplates.Registry.get(glob <> ".spt")
#    body = Simplate.render(simplate)
#
#    send_resp(conn, 200, body)
#  end 

#  def try_thing do
#    get "/hello" do
#      send_resp(conn, 200, "world")
#    end
#  end

end
