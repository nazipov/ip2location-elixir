defmodule IP2Location.Mixfile do
  use Mix.Project

  def project do
    [app: :ip2location,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [
      mod: { IP2Location, [] },
      applications: [ :poolboy ]
    ]
  end

  defp deps do
    [{:poolboy, "~> 1.0"}]
  end

  defp description do
    """
    An Elixir library for the IP2Location database.
    """
  end

  defp package do
    [
      maintainers: ["Almaz Nazipov"],
      licenses:    ["GNU LGPLv3"],
      links:       %{ "GitHub" => "https://github.com/nazipov/ip2location-elixir" }
    ]
  end
end
