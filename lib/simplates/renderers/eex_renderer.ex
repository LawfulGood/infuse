defmodule Infuse.Simplates.Renderers.EExRenderer do
    
    def render(compiled, context) do
        {out, _} = Code.eval_quoted(compiled, context)
        out
    end

    def compile(content) do
        EEx.compile_string(content)
    end
end
