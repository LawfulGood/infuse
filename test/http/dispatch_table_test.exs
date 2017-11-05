defmodule Infuse.HTTP.DispatchTableTest do
  use ExUnit.Case, async: false
  use Plug.Test

  require Logger

  ExUnit.Case.register_attribute __ENV__, :test_path
  ExUnit.Case.register_attribute __ENV__, :test_files
  ExUnit.Case.register_attribute __ENV__, :test_code

  alias Infuse.HTTP.SimplateDispatch, as: SimplateDispatch

  @website_router_opts Infuse.HTTP.Pipeline.init([])

  #inputs = File.stream!("test/http/dispatch_table_inputs.csv") |> CSV.decode([headers: true]) |> Enum.to_list()
  #outputs = File.stream!("test/http/dispatch_table_outputs.csv") |> CSV.decode([headers: true]) |> Enum.to_list()

  generic_simplate = "<script>\n</script>\n<template>\n</template>"

  test_rows = File.stream!("test/http/dispatch_table_simple.csv") |> CSV.decode()

  headers = test_rows |> Enum.at(0)
  test_rows = test_rows |> Enum.drop(1)

  files = Enum.slice(headers, 0, 7)
  request_paths = Enum.slice(headers, 7, 5)


  # defmacro test_request(method, path, {expected_code, expected_file}) do
  #   quote do
  #     test "#{method} #{path} == #{expected}", %{conn: conn} do
  #       method = unquote(method)
  #       path = unquote(path)
  #       expected_code = unquote(expected_code)
  #       expected_file = unquote(expected_file)

  #       conn = conn(method, path)
  #       call = Infuse.HTTP.Pipeline.call(conn, Infuse.HTTP.Pipeline.init([]))

  #       assert conn.state == :sent
  #       assert call.status == expected_code
  #     end
  #   end
  # end

  # Setups can also invoke a local or imported function
  # setup :invoke_local_or_imported_function

  setup context do
    # Delete previous test files
    {:ok, files} = File.ls(Infuse.config(:web_root))
    files = Enum.reject(files, fn(file) -> file == ".gitignore" end)

    for file <- files do
      File.rm!(Path.join([Infuse.config(:web_root), file]))
    end

    # Create new test files
    for file <- context.registered.test_files do
      file = Path.join([Infuse.config(:web_root), file])
      File.write(file, "<script>\n</script>\n<template>\nHello, program!\n</template>")
    end

    :ok
  end

  for row <- test_rows do
    file_status = Enum.slice(row, 0, 7) |> Enum.with_index()
    requests = Enum.slice(row, 7, 5)

    for {result, i} <- Enum.with_index(requests) do
      request_path = request_paths |> Enum.at(i)

      files_to_make = Enum.filter(file_status, fn({action, findex}) ->
        case action do
          "X" -> true
          _ -> false
        end
      end)

      files_to_make = Enum.reduce(files_to_make, [], fn({_, findex}, acc) -> acc ++ [Enum.at(files, findex)] end)
      string_files = files_to_make |> Enum.join(", ")

      Logger.info("Generating test that GET #{request_path} recieves #{result} with #{string_files}")

      code = Regex.run(~r/(\d{3})/, result) |> hd() |> String.to_integer()

      # test_request(:get, request_path, {200, ""})
      @test_path request_path
      @test_files files_to_make
      @test_code code
      test "that GET #{request_path} recieves #{result} with #{string_files}", context do
        Infuse.HTTP.SimplateRouter.unregister_all()
        Infuse.Simplates.Loader.autoload(Infuse.config(:web_root))
        
        conn = conn(:get, context.registered.test_path)
        conn = Infuse.HTTP.Pipeline.call(conn, @website_router_opts)

        #assert conn.state == :sent
        assert conn.status == context.registered.test_code

        #assert true == true
      end
    end
  end


  # line = 0
  # for row <- inputs do

  #   # Setup
  #   for {file, action} <- row do

  #     case action do
  #       "X" -> IO.puts("Create: #{file}")
  #       _ -> IO.puts("Ignore: #{file}") 
  #     end
      
  #     #IO.inspect({column, header})
  #     #rand = :rand.uniform(100000000)
  #     #test "test #{column} == #{header} e#{rand}" do
  #     #  assert true == true
  #     #end
  #   end

  #   # Tests
  #   for {rpath, result} <- Enum.at(outputs, line) do
  #     IO.puts("GET #{rpath} SHOULD #{result}")
  #   end

  #   line = line + 1
  #   IO.inspect(line)
  # end

end
