defmodule Infuse.Simplates.SpeclineTest do
    use ExUnit.Case, async: true

    doctest Infuse.Simplates.Specline

    test "parses specline" do
        parsed = Infuse.Simplates.Specline.parse_specline("media/type via EEx")
        assert parsed == {:ok, Infuse.Simplates.Renderers.EExRenderer, "media/type"}
    end

    test "parses specline without renderer" do
        parsed = Infuse.Simplates.Specline.parse_specline("media/type")
        assert parsed == {:ok, Infuse.Simplates.Renderers.EExRenderer, "media/type"}
    end

    test "parses specline without content type" do
        parsed = Infuse.Simplates.Specline.parse_specline("via EEx")
        assert parsed == {:ok, Infuse.Simplates.Renderers.EExRenderer, "text/html"}
    end
end
