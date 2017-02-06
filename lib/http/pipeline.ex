defmodule Infuse.HTTP.Pipeline do
  @moduledoc """
  The main HTTP pipeline for serving requests. 

  The firing order is:
   * Simplate Routes
   * Static Requests
   * Not Found
  """

  use Plug.Builder

  plug Plug.Logger, log: :debug

  plug Plug.Static,
    at: "/",
    from: Infuse.config_web_root

  plug Infuse.HTTP.SimplateRouter

  plug :not_found

  def not_found(conn, _) do
    conn
    |> send_resp(404, "Could not find: " <> Infuse.config_web_root <> conn.request_path)
    |> halt
  end

end
