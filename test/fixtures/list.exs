defmodule IP2Location.TestFixtures.List do
  @fixtures_path [__DIR__] |> Path.expand()

  def download() do
    Enum.each(fixtures(), &download_fixture/1)
  end

  def fixture_path(fixture_name) do
    {_, _, filename} = fixtures() |> Enum.find(fn({n, _, _}) -> n == fixture_name end)
    localname(filename)
  end

  defp download_fixture({name, url, filename}) do
    unless File.regular?(localname(filename)) do
      Mix.shell.info [ :yellow, "Downloading fixture #{name} from #{url}" ]
      [
        "cd #{@fixtures_path}",
        "wget -q #{url} -O #{Path.basename(url)}",
        "unzip -u -qq #{Path.basename(url)} #{filename}"
      ] 
      |> Enum.join(" && ") 
      |> String.to_charlist 
      |> :os.cmd
    end
  end

  defp fixtures() do
    [
      {
        :fixture_ipv4_db1, "https://www.ip2location.com/downloads/sample.bin.db1.zip",  
          "IP-COUNTRY-SAMPLE.BIN"
      },
      {
        :fixture_ipv6_db1, "https://www.ip2location.com/downloads/sample6.bin.db1.zip", 
          "IPV6-COUNTRY.SAMPLE.BIN",
      },
      {
        :fixture_ipv6_db24, "https://www.ip2location.com/downloads/sample6.bin.db24.zip",
          "IPV6-COUNTRY-REGION-CITY-LATITUDE-LONGITUDE-ZIPCODE-TIMEZONE-ISP-DOMAIN-NETSPEED-AREACODE-WEATHER-MOBILE-ELEVATION-USAGETYPE.SAMPLE.BIN"
      }
    ]
  end

  defp localname(filename) do
    [ __DIR__, filename ]
    |> Path.join()
    |> Path.expand()
  end
end