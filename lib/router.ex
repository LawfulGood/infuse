defmodule Aspen.Router do
  use Plug.Router

  plug :match 
  plug :dispatch

  match "/*glob" do
    body = Simplate.render("www/#{glob}.spt")

    send_resp(conn, 200, body)
  end 

end