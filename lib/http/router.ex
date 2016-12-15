defmodule Infuse.HTTP.Router do
  use Plug.Router
  use Plug.Debugger 
  use Plug.ErrorHandler

  plug :match 
  plug :dispatch
  plug Plug.Logger, log: :debug

  forward "/", to: Infuse.HTTP.Dispatch

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
