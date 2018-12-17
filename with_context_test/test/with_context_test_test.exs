defmodule WithContextTestTest do
  use ExUnit.Case
  doctest WithContextTest

  test "greets the world" do
    assert WithContextTest.hello() == :world
  end
end
