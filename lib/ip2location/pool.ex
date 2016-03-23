defmodule IP2Location.Pool do
  def child_spec do
    opts = [
      name:          { :local, __MODULE__ },
      worker_module: IP2Location.Server,
      size:          5,
      max_overflow:  10
    ]

    :poolboy.child_spec(__MODULE__, opts, [])
  end

   def lookup(ip) do
    :poolboy.transaction(
      __MODULE__,
      &GenServer.call(&1, { :lookup, ip })
    )
  end
end