defmodule IP2Location.Database.LoaderTest do
  use ExUnit.Case, async: false

  import IP2Location.TestFixtures.List, only: [fixture_path: 1]

  test "load invalid databse" do
    assert { :error, _ } = IP2Location.load_database("unvalid_file")
  end

  test "load valid databse" do
    assert { :ok, _ } = IP2Location.load_database(fixture_path(:fixture_ipv6_db1))
  end
end