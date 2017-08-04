defmodule Infuse.Simplates.LoaderTest do
  use ExUnit.Case

  alias Infuse.Simplates.Loader, as: Loader

  test "remove webroot removes webroot" do
    orig = Path.join(Infuse.config(:web_root), "somepath")

    assert Loader.remove_webroot(orig) == "/somepath"
  end

  test "determines simple route for /about/home/index.html.spt" do
    expected = ["/about/home/", "/about/home/index", "/about/home/index.html"]

    simplate = Simplates.Simplate.create("<script>\n</script>\n<template>\nHello, program!\n</template>", "/about/home/index.html.spt")

    IO.inspect(Loader.determine_routes(simplate))
    
    assert Loader.determine_routes(simplate) == expected
  end

end
