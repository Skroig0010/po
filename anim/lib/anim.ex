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
        case trunc((:math.sin(rad + x / 4) + 1.0) * 4) do
          a when a < y -> [trunc((:math.sin(rad) + 1.0) * 128), trunc((:math.sin(rad + 1) + 1.0) * 128), trunc((:math.sin(rad + 2) + 1.0) * 128)]
          a when a == y -> [trunc((:math.sin(rad) + 1.0) * 64), trunc((:math.sin(rad + 1) + 1.0) * 64), trunc((:math.sin(rad + 2) + 1.0) * 64)]
          a when a > y -> [0, 0, 0]
        end
      end)
    end)
    Python.call(:"sense.set_pixels", [cells])
    loop(rad + 0.01)
  end
end
