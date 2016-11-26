defmodule Infuse.Simplates.PaginationTest do
  use ExUnit.Case
  doctest Infuse

  test "static simplate" do 
    simplate = Simplate.load_file("test/fake-www/static.spt")

    assert Simplate.render(simplate) == "Hello world!"
  end

  test "complex simplate" do 
    simplate = Simplate.load_file("test/fake-www/complex.spt")

    assert Simplate.render(simplate, "text/plain") == "foodbar"
  end

  test "multipart simplate" do
    simplate = Simplate.load_file("test/fake-www/multipage.spt")

    assert Simplate.render(simplate, "text/plain") == "Hello world!"

    assert Simplate.render(simplate, "application/json") == ~s("Hello world!")
  end

  #assert String.contains?(Simplates.parse(file), "<h1>Html!! test</h1>") == true

  test "the truth" do
    assert 1 + 1 == 2
  end
end
