defmodule IP2Location.ResultTest do
  use ExUnit.Case, async: false

  import IP2Location.TestFixtures.List, only: [fixture_path: 1]

  test "fields value types" do
    assert {:ok, _} = IP2Location.load_database(fixture_path(:fixture_ipv6_db24))

    result = IP2Location.lookup("2A04::1")

    assert is_tuple(result.ip)
    assert is_binary(result.country)
    assert is_binary(result.country_long)
    assert is_binary(result.region)
    assert is_binary(result.city)
    assert is_binary(result.isp)
    assert is_float(result.latitude)
    assert is_float(result.longitude)
    assert is_binary(result.domain)
    assert is_binary(result.zipcode)
    assert is_binary(result.timezone)
    assert is_binary(result.netspeed)
    assert is_binary(result.iddcode)
    assert is_binary(result.areacode)
    assert is_binary(result.weatherstationcode)
    assert is_binary(result.weatherstationname)
    assert is_binary(result.mcc)
    assert is_binary(result.mnc)
    assert is_binary(result.mobilebrand)
    assert is_binary(result.elevation)
    assert is_binary(result.usagetype)
  end

  test "empty fields" do
    assert {:ok, _} = IP2Location.load_database(fixture_path(:fixture_ipv6_db1))

    result = IP2Location.lookup("2A04::1")

    assert is_tuple(result.ip)
    assert is_binary(result.country)
    assert is_binary(result.country_long)
    assert is_nil(result.region)
    assert is_nil(result.city)
    assert is_nil(result.isp)
    assert is_nil(result.latitude)
    assert is_nil(result.longitude)
    assert is_nil(result.domain)
    assert is_nil(result.zipcode)
    assert is_nil(result.timezone)
    assert is_nil(result.netspeed)
    assert is_nil(result.iddcode)
    assert is_nil(result.areacode)
    assert is_nil(result.weatherstationcode)
    assert is_nil(result.weatherstationname)
    assert is_nil(result.mcc)
    assert is_nil(result.mnc)
    assert is_nil(result.mobilebrand)
    assert is_nil(result.elevation)
    assert is_nil(result.usagetype)
  end
end