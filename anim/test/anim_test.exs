defmodule AnimTest do
  use ExUnit.Case
  doctest Anim

  test "greets the world" do
    assert Anim.hello() == :world
  end
end
