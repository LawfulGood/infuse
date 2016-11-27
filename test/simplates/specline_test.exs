defmodule Infuse.Simplates.SpeclineTest do
    use ExUnit.Case, async: true

    doctest Infuse.Simplates.Specline

    test "parses specline" do
        assert Infuse.Simplates.Specline.parse_specline("media/type via EEx") == {:ok, "EEx", "media/type"}
    end

    test "parses specline without renderer" do
        assert Infuse.Simplates.Specline.parse_specline("media/type") == {:ok, "EEx", "media/type"}
    end

    test "parses specline without content type" do
        assert Infuse.Simplates.Specline.parse_specline("via EEx") == {:ok, "EEx", "text/html"}
    end
end
