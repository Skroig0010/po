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
        lumi = (:math.sin(rad + x / 4.0) + 1.0) / 2.0 * (y + 1) / 8.0
        [trunc((:math.sin(rad) + 1.0) * 128 * lumi), trunc((:math.sin(rad + 1) + 1.0) * 128 * lumi), trunc((:math.sin(rad + 2) + 1.0) * 128)]
      end)
    end)
    Python.call(:"sense.set_pixels", [cells])
    loop(rad + 0.01)
  end
end
