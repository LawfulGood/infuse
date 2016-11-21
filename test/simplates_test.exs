defmodule SimplatesTest do
  use ExUnit.Case
  doctest Aspen

  test "static simplate" do 
    simplate = Simplate.load("test/simplates/static.spt")

    assert Simplate.render(simplate) == "Hello world!"
  end

  test "parses one page" do
    raw = "One page"

    assert length(Simplate.parse_pages(raw)) == 3
  end


  test "parses two pages" do
    raw = "
    top
    [---]
    bottom
    "

    assert length(Simplate.parse_pages(raw)) == 3
  end


  test "parses three pages" do
    raw = "
    once
    [---]
    every
    [---]
    template
    "

    assert length(Simplate.parse_pages(raw)) == 3
  end


  #assert String.contains?(Simplates.parse(file), "<h1>Html!! test</h1>") == true

  test "the truth" do
    assert 1 + 1 == 2
  end
end
