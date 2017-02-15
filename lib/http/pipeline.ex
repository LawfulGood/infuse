defmodule Infuse.HTTP.Pipeline do
  @moduledoc """
  The main HTTP pipeline for serving requests. 

  The firing order is:
   * Static Requests
   * Simplate Routes
   * Not Found
  """

  use Plug.Builder

  if Mix.env == :dev do
    use Plug.Debugger, otp_app: :infuse, style: [primary: "#00A359", logo: "data:image/png;base64,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"]
  end

  plug Plug.Logger, log: :debug

  plug Plug.Static,
    at: "/",
    from: Infuse.config(:web_root)

  plug Infuse.HTTP.SimplateRouter

  plug :not_found

  def not_found(conn, _) do
    conn
    |> send_resp(404, "Could not find: " <> Infuse.config(:web_root) <> conn.request_path)
    |> halt
  end

end
