defmodule SecomTest do
  use ExUnit.Case
  doctest Secom

  test "greets the world" do
    assert Secom.hello() == :world
  end
end
