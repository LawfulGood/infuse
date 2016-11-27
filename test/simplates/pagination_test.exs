defmodule Infuse.Simplates.PaginationTest do
  use ExUnit.Case
  doctest Infuse


  test "single page adds two code pages" do 
    simplate = Simplate.load("Hello, world! I have no code!")

    assert simplate.once.content == ""
    assert simplate.every.content == ""
  end

  test "two page adds one code page" do
    simplate = Simplate.load("
      some_code = 2
      [----]
      Hello, world! I have SOME code!")

    assert simplate.once.content == ""
    assert String.trim(simplate.every.content) == "some_code = 2"
  end


  test "three page does nothing" do
    simplate = Simplate.load("
      some_global_var = 3
      [----]
      some_code = 2
      [----]
      Hello, world! I have ALL code!")

    assert String.trim(simplate.once.content) == "some_global_var = 3"
    assert String.trim(simplate.every.content) == "some_code = 2"
    assert Simplate.render(simplate) == "\n      Hello, world! I have ALL code!" # Why does this happen
  end


  test "three four does nothing" do
    simplate = Simplate.load("
      some_global_var = 3
      [----]
      some_code = 2
      [----] text/plain
      Hello, world! I have ALL plain code!
      [----] application/json
      Hello world I have all JSON code!")

    assert String.trim(simplate.once.content) == "some_global_var = 3"
    assert String.trim(simplate.every.content) == "some_code = 2"
    assert Simplate.render(simplate,"application/json") == "Hello world I have all JSON code!"
  end


end
