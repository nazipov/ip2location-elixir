defmodule IP2Location.Database.Storage do
  def start_link(), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key, nil))
  end

  def set(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end
end