defmodule MyContextExSample2Test do
  use ExUnit.Case
  doctest MyContextExSample2

  test "greets the world" do
    assert MyContextExSample2.hello() == :world
  end
end
