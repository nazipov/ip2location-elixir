# IP2Location

Elixir library for the IP2Location database. Supports IPv4 and IPv6.

# Installation

Add IP2Location as a dependency to your project's `mix.exs`:

```elixir
def application do
  [applications: [:ip2location]]
end

defp deps do
  [{:ip2location, github: "nazipov/ip2location-elixir"}]
end
```

and then run `$ mix deps.get`

# Configuration

Add the path of the IP2Location database to your project's configuration:

```elixir
use Mix.Config

database_file =
  [ __DIR__, "../data/sample-ipv6-db24.bin" ]
    |> Path.join()
    |> Path.expand()

config :ip2location,
  database: database_file,
  pool: [ size: 5, max_overflow: 10 ]
```

# Usage

```elixir
iex(1)> IP2Location.lookup("8.8.8.8")
%IP2Location.Result{ ... }
iex(1)> IP2Location.lookup("2001:4860:4860::8888")
%IP2Location.Result{ ... }
```

# Benchmarking

```elixir
iex(1)> :timer.tc(fn -> IP2Location.lookup("8.8.8.8") end )
{150, %IP2Location.Result{ ... }}
iex(2)> :timer.tc(fn -> IP2Location.lookup("2001:4860:4860::8888") end )
{152, %IP2Location.Result{ ... }}
```

# Sample BIN Databases

* Download free IP2Location LITE databases at [http://lite.ip2location.com](http://lite.ip2location.com)  
* Download IP2Location sample databases at [http://www.ip2location.com/developers](http://www.ip2location.com/developers)

# License

[GNU LGPLv3](http://www.gnu.org/licenses/lgpl-3.0.html)