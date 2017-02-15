defmodule Infuse.Simplates.LoaderTest do
  use ExUnit.Case

  alias Infuse.Simplates.Loader, as: Loader

  test "remove webroot removes webroot" do
    orig = Path.join(Infuse.config(:web_root), "somepath")

    assert Loader.remove_webroot(orig) == "/somepath"
  end

  test "determines simple route" do
    expected = ["/about/home/"]
    
    assert Loader.determine_routes("/about/home/index.spt") == expected
  end

end
