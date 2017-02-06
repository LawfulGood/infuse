defmodule Infuse.Simplates.Hotreload.ChangeEvent do
  use GenEvent
  
  require Logger
  
  def handle_event({:file, x}, messages) do
    Logger.info("Hotreload: Change event on " <> x)
    {:ok, [x | messages]}
  end

  def handle_call(:messages, messages) do
    {:ok, Enum.reverse(messages), []}
  end

end
