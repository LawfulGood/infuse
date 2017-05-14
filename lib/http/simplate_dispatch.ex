defmodule Infuse.HTTP.SimplateDispatch do
  @moduledoc """
  Handle the Simplate HTTP Dispatch

  The Infuse.HTTP.SimplateRouter is used for determining if the simplate is 
  valid and sending it here
  """
  import Plug.Conn
  
  def init(opts) do
    opts
  end

  def call(pre_conn, opts) do
    simplate = opts.simplate

    pre_conn = pre_conn
                |> put_status(200)
                #|> put_resp_content_type(Simplate.default_content_type)
    
    # TODO: Need to review this
    pre_conn = case get_req_header(pre_conn, "accept") do
      [] -> put_req_header(pre_conn, "accept", Infuse.config(:default_content_type))
      _ -> pre_conn
    end

    content_types = []
      |> path_content_types(pre_conn.request_path)
      |> accept_content_types(hd(get_req_header(pre_conn, "accept")))

    %{:output => output, :content_type => content_type, :bindings => bindings} = try_render(simplate, content_types, [conn: pre_conn])

    conn = bindings[:conn]
    
    conn 
    |> put_resp_content_type(content_type)
    |> send_resp(conn.status, output)
    |> halt()
  end

  def try_render(simplate, content_types, context) do
    found_types = Enum.filter(simplate.templates, fn({content_type, _page}) -> 
      Enum.member?(content_types, content_type)
    end)

    unless length(found_types) >= 1 do
      raise "could not find an acceptable template"
    end

    {acceptable_type, _} = hd(found_types)
    
    Simplates.Simplate.render(simplate, acceptable_type, context)
  end
  
  def path_content_types(types, path) do
    ext = path |> Path.extname() |> String.trim_leading(".")
    if MIME.has_type?(ext) do
      types ++ [MIME.type(ext)]
    else
      types
    end
  end

  def accept_content_types(types, accept_header) do
    new_types = Enum.map(String.split(accept_header, ","), fn(accept) ->
      # Uses this library to deal with quality parsing, we might later use :mimeparse.best_match
      {app, type, _} = :mimeparse.parse_mime_type(to_charlist(accept))
      
      "#{app}/#{type}"
      end) 

    types ++ new_types
  end

end
