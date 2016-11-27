defmodule Infuse.Simplates.Renderers.CodeRenderer do
    
    def render(compiled, context \\ []) do
        Code.eval_quoted(compiled, context)
    end

    def compile(content) do
        Code.string_to_quoted!(content)
    end
end
