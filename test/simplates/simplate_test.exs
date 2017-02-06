defmodule Infuse.Simplates.SimplateTest do
  use ExUnit.Case

  setup do
    Infuse.Simplates.Registry.start_link

    on_exit fn ->
      Infuse.Simplates.Registry.stop
    end
  end

  test "static simplate" do 
    {:ok, simplate} = Simplate.load_file("test/fake-www/static.spt")

    assert Simplate.render(simplate) == "Hello world!"
  end

  test "complex simplate" do 
    {:ok, simplate} = Simplate.load_file("test/fake-www/complex.spt")

    assert Simplate.render(simplate, "text/plain") == "foodbar"
  end

  test "multipart simplate" do
    {:ok, simplate} = Simplate.load_file("test/fake-www/multipage.spt")

    assert Simplate.render(simplate, "text/plain") == "Hello world!"

    assert Simplate.render(simplate, "application/json") == ~s("Hello world!")
  end

  test "finding simplate by full path" do
    {:ok, simplate} = Simplate.load_file("test/fake-www/multipage.spt")
    res = Simplate.find_by_fullpath("/multipage.spt")

    assert res == {:ok, simplate}
  end

  #assert String.contains?(Simplates.parse(file), "<h1>Html!! test</h1>") == true

  test "the truth" do
    assert 1 + 1 == 2
  end
end
