defmodule Infuse do
  use Application

  def start(_type, _args) do
    Infuse.Supervisor.start_link
  end
end
