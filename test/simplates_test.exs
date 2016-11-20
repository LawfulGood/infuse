defmodule SimplatesTest do
  use ExUnit.Case
  doctest Aspen

  test "loads simple" do
    file = "examples/simple.spt"

    assert String.contains?(Simplates.parse(file), "<h1>Html!! test</h1>") == true
    
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
