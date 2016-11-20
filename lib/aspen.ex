defmodule Aspen do
  use Application

  def start(_type, _args) do
    Aspen.Supervisor.start_link
  end
end
