defmodule Anim do
  @moduledoc """
  Documentation for Anim.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Anim.hello
      :world

  """
  def hello do
    Python.init()
    loop(0.0)
  end

  def loop(rad) do
    cells = Enum.flat_map(0..7, fn y ->
      Enum.map(0..7, fn x ->
        case trunc(qubic(rem(trunc(rad * 10) + x, 10) / 10)) do
          a when a <= y -> [trunc((:math.sin(rad) + 1.0) * 128), trunc((:math.sin(rad + 1) + 1.0) * 128), trunc((:math.sin(rad + 2) + 1.0) * 128)]
            IO.inspect a
          a when a > y -> [0, 0, 0]
            IO.inspect a
        end
      end)
    end)
    Python.call(:"sense.set_pixels", [cells])
    loop(rad + 0.01)
  end

  def qubic(x) do
    x = x * 2
    if x < 1 do
      x * x * x / 2
    else 
      x = x - 2
      (x * x * x + 2) / 2
    end
  end
end
