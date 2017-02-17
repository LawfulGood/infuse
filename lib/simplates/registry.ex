defmodule Infuse.Simplates.Registry do
  @moduledoc """
  A simple GenServer to keep track of Simplates
  """
  use GenServer
  require Logger

  @doc """
  Creates a key => value store for simplates.
      iex> Infuse.Simplates.Registry.start_link
      iex> Infuse.Simplates.Registry.stop
      :ok
  """
  def start_link do
    Logger.info("Worker: Started Infuse.Simplates.Registry")
    GenServer.start(__MODULE__, [], name: :simplate_server)
  end
  
  @doc """
  Add a simplate to the registry
      iex> Infuse.Simplates.Registry.start_link
      iex> Infuse.Simplates.Registry.put "index.spt", %Page{}
      iex> Infuse.Simplates.Registry.get "index.spt"
      %Page{}
      iex> Infuse.Simplates.Registry.stop
      :ok
  """
  def put(key, value) do
    GenServer.cast(:simplate_server, { :set, key, value })
  end

  @doc """
  Return the value associated with `key`, or `nil`
  is there is none.
      iex> Infuse.Simplates.Registry.start_link
      iex> Infuse.Simplates.Registry.put "index.spt", %Page{}
      iex> Infuse.Simplates.Registry.get "index.spt"
      %Page{}
      iex> Infuse.Simplates.Registry.stop
      :ok
  """
  def get(key) do
    GenServer.call(:simplate_server, { :get, key })
  end

  @doc """
  Delete the entry corresponding to a key from the store
  
      iex> Infuse.Simplates.Registry.start_link
      iex> Infuse.Simplates.Registry.put "index.spt", %Page{}
      iex> Infuse.Simplates.Registry.get "index.spt"
      %Page{}
      iex> Infuse.Simplates.Registry.delete "index.spt"
      iex> Infuse.Simplates.Registry.get "index.spt"
      nil
      iex> Infuse.Simplates.Registry.stop
      :ok

  """
  def delete(key) do
    GenServer.cast(:simplate_server, { :remove, key })
  end

  @doc """
  Stop the simplate server
  """
  def stop do
    GenServer.stop(:simplate_server)
  end

  # SERVER
  def init(args) do
    { :ok, Enum.into(args, %{}) }
  end

  def handle_cast({ :set, key, value }, state) do
    { :noreply, Map.put(state, key, value) }
  end

  def handle_cast({ :remove, key }, state) do
    { :noreply, Map.delete(state, key) }
  end

  def handle_call({ :get, key }, _from, state) do
    { :reply, state[key], state }
  end
end
