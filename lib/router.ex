defmodule Aspen.Router do
  use Plug.Router

  plug :match 
  plug :dispatch

  match "/*glob" do
    simplate = Simplate.load("www/#{glob}.spt")
    body = Simplate.render(simplate)

    send_resp(conn, 200, body)
  end 

end