defmodule IP2Location do
  use Application

  alias IP2Location.Pool

  def start(_type, _args) do
    import Supervisor.Spec

    options = [ strategy: :one_for_one, name: IP2Location.Supervisor ]
    children = [
      Pool.child_spec,
      supervisor(IP2Location.Database.Supervisor, [])
    ]

    Supervisor.start_link(children, options)
  end

  defdelegate lookup(ip), to: IP2Location.Pool
end
