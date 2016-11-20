defmodule Simplates do
  
  def parse(file) do
    {:ok, body} = File.read(file)

    [once, every, template] = String.split(body, "[---]", trim: true)

    {_, once_bindings} = Code.eval_string(once)
    {_, bindings} = Code.eval_string(every, once_bindings)

    EEx.eval_string(template, bindings)
  end

end