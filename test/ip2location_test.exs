defmodule IP2LocationTest do
  use ExUnit.Case
  doctest IP2Location

  test "application should start" do
    {result, _} = IP2Location.start(:normal, [])
    assert result == :ok
  end
end
