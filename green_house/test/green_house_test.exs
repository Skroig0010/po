defmodule GreenHouseTest do
  use ExUnit.Case
  doctest GreenHouse

  test "greets the world" do
    assert GreenHouse.hello() == :world
  end
end
