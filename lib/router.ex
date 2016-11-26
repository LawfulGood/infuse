defmodule Infuse.Router do
  use Plug.Router

  plug :match 
  plug :dispatch
  plug Plug.Logger, log: :debug

  match "/*glob" do
    glob = case glob do
      [] -> "index"
      _ -> glob
    end
    
    simplate = Infuse.Simplates.Registry.get(glob <> ".spt")
    body = Simplate.render(simplate)

    send_resp(conn, 200, body)
  end 

end
