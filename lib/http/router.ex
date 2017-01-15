defmodule Infuse.HTTP.Router do
  use Plug.Router
  use Plug.Debugger 
  use Plug.ErrorHandler

  plug :match 
  plug :dispatch
  plug Plug.Logger, log: :debug

  forward "/", to: Infuse.HTTP.Dispatch

  def handle_notfound(conn) do
    send_resp(conn, 404, "oops")
  end

end
