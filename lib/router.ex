defmodule Infuse.Router do
  use Plug.Router

  plug :match 
  plug :dispatch

  match "/*glob" do
    simplate = Infuse.Simplates.Registry.get("www/#{glob}.spt")
    body = Simplate.render(simplate)

    send_resp(conn, 200, body)
  end 

end
