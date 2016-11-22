defmodule SimplatesTest do
  use ExUnit.Case
  doctest Infuse

  test "static simplate" do 
    simplate = Simplate.load("test/fake-www/static.spt")

    assert Simplate.render(simplate) == "Hello world!"
  end

  test "complex simplate" do 
    simplate = Simplate.load("test/fake-www/complex.spt")

    assert Simplate.render(simplate) == "foodbar"
  end

  test "parses specline" do
    assert Simplate.parse_specline("media/type via EEx") == {"EEx", "media/type"}
  end

  test "parses specline without renderer" do
    assert Simplate.parse_specline("media/type") == {"", "media/type"}
  end

  test "parses specline without content type" do
    assert Simplate.parse_specline("via EEx") == {"EEx", ""}
  end

  #assert String.contains?(Simplates.parse(file), "<h1>Html!! test</h1>") == true

  test "the truth" do
    assert 1 + 1 == 2
  end
end
