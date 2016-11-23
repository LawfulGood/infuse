defmodule Simplates.PageTest do
  use ExUnit.Case
  doctest Infuse

  test "single page adds two code pages" do 
    simplate = Simplate.load("Hello, world! I have no code!")

    assert Simplate.render(simplate) == "Hello, world! I have no code!"
  end

end
