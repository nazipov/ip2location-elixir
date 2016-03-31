defmodule IP2LocationTest do
  use ExUnit.Case, async: false
  doctest IP2Location

  import IP2Location.TestFixtures.List, only: [fixture_path: 1]

  test "ipv4 lookup" do
    assert {:ok, _} = IP2Location.load_database(fixture_path(:fixture_ipv4_db1))
    assert %IP2Location.Result{} = IP2Location.lookup("8.8.8.8")
  end

  test "ipv6 lookup in ipv4 database" do
    assert {:ok, _} = IP2Location.load_database(fixture_path(:fixture_ipv4_db1))
    assert nil == IP2Location.lookup("2A04::1")
  end

  test "ipv6 lookup" do
    assert {:ok, _} = IP2Location.load_database(fixture_path(:fixture_ipv6_db1))
    assert %IP2Location.Result{} = IP2Location.lookup("2A04::1")
  end
end
