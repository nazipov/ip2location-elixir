defmodule IP2Location.Server do
  use GenServer
  @behaviour :poolboy_worker

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default)
  end

  def handle_call({ :lookup, ip }, _, state) do
    { :reply, IP2Location.Database.lookup(ip), state }
  end
end