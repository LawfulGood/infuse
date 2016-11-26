defmodule Infuse.Simplates.Renderers.EExRenderer do
    
    def render(compiled, context) do
        EEx.eval_string(compiled, context)
    end

end
