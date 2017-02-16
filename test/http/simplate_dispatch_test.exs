defmodule Infuse.HTTP.SimplateDispatchTest do
  use ExUnit.Case

  alias Infuse.HTTP.SimplateDispatch, as: SimplateDispatch

  test "accept content types generates correctly" do 
    accept_header = "text/html,application/xhtml+xml,*/*;q=0.8"
    assert SimplateDispatch.accept_content_types([], accept_header) == ["text/html","application/xhtml+xml","*/*"]
  end 

end
