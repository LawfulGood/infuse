defmodule Infuse.HTTP.Router do
  use Plug.Router
  use Plug.Debugger 
  use Plug.ErrorHandler

  plug :match 
  plug :dispatch
  plug Plug.Logger, log: :debug

  match "/*glob" do
     raise "oops"

    glob = case glob do
      [] -> "index"
      _ -> glob
    end
    
    simplate = Infuse.Simplates.Registry.get(glob <> ".spt")
    body = Simplate.render(simplate)

    send_resp(conn, 200, body)
  end 

end
