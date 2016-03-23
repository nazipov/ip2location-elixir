use Mix.Config

path_db =
     [ __DIR__, "../data/ip2location.bin" ]
  |> Path.join()
  |> Path.expand()

config :ip2location,
  database: path_db