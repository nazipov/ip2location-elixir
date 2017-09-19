defmodule IP2Location do
  use Application

  alias IP2Location.Pool
  alias IP2Location.Database.Loader

  def start(_type, _args) do
    import Supervisor.Spec

    options = [ strategy: :one_for_one, name: IP2Location.Supervisor ]
    children = [
      Pool.child_spec,
      supervisor(IP2Location.Database.Supervisor, [])
    ]

    Supervisor.start_link(children, options)
  end

  def load_database(filename) do
    GenServer.call(Loader, { :load_database, filename }, :infinity)
  end

  def lookup(ip) when is_binary(ip) do
    ip = String.to_charlist(ip)

    case :inet.parse_address(ip) do
      { :ok, parsed } -> lookup(parsed)
      { :error, _ }   -> nil
    end
  end

  def lookup(ip) do
    :poolboy.transaction(Pool, &GenServer.call(&1, { :lookup, ip }))
  end
end
