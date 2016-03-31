use Mix.Config

path_db =
     [ __DIR__, "../data/sample-ipv6-db24.bin" ]
  |> Path.join()
  |> Path.expand()

config :ip2location,
  database: path_db,
  pool: [ size: 5, max_overflow: 10 ]