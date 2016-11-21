defmodule Infuse.Simplates.RegistryTest do
    use ExUnit.Case, async: true

    setup do
        {:ok, registry} = Infuse.Simplates.Registry.start_link
        {:ok, registry: registry}
    end 

    test "stores simplate", %{registry: registry} do
        assert Infuse.Simplates.Registry.get(registry, "index.spt") == nil

        blank_simplate = %Simplate{}

        Infuse.Simplates.Registry.put(registry, "index.spt", blank_simplate)
        assert Infuse.Simplates.Registry.get(registry, "index.spt") == blank_simplate
    end
end
