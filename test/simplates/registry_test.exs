defmodule Infuse.Simplates.RegistryTest do
    use ExUnit.Case, async: true

    doctest Infuse.Simplates.Registry

    test "stores simplate" do
        Infuse.Simplates.Registry.start_link
        assert Infuse.Simplates.Registry.get("index.spt") == nil

        blank_simplate = %Simplate{}

        Infuse.Simplates.Registry.put("index.spt", blank_simplate)
        assert Infuse.Simplates.Registry.get("index.spt") == blank_simplate
    end
end
