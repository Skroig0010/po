defmodule TimeMeasurerTest do
  use ExUnit.Case
  doctest TimeMeasurer

  test "greets the world" do
    assert TimeMeasurer.hello() == :world
  end
end
