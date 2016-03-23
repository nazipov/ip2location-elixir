defmodule IP2Location.Database.Supervisor do
  use Supervisor

  alias IP2Location.Database

  def start_link(default \\ []) do
    Supervisor.start_link(__MODULE__, default)
  end

  def init(_default) do
    database = Application.get_env(:ip2location, :database, [])
    children = [
      worker(Database.Storage, []),

      worker(Database.Loader, [database])
    ]

    supervise(children, strategy: :one_for_all)
  end
end