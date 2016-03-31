defmodule IP2Location.Pool do
  def child_spec do
    opts = [
      name:          { :local, __MODULE__ },
      worker_module: IP2Location.Server,
      size:          Application.get_env(:ip2location, :pool)[:size] || 5,
      max_overflow:  Application.get_env(:ip2location, :pool)[:max_overflow] || 10
    ]

    :poolboy.child_spec(__MODULE__, opts, [])
  end
end