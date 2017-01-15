defmodule Infuse.HTTP.Router do
  use Plug.Router
  use Plug.Debugger 
  use Plug.ErrorHandler

  plug Plug.Logger, log: :debug
  plug :match 
  plug :dispatch
  plug Plug.Static,
    at: Infuse.web_root,
    from: :Infuse,
    only: ~w(css robots.txt)

  forward "/", to: Infuse.HTTP.Dispatch

  def try_static(conn) do
    
    case File.exists?(conn.request_path) do
      true -> handle_static(conn)
      false -> handle_notfound(conn)
    end

  end

  def handle_static(conn) do
    
  end

  def handle_notfound(conn) do
    send_resp(conn, 404, "oops")
  end

end
