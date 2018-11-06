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
        if(y < (:math.sin(rad) + 1.0) * 4) do
          [trunc((:math.sin(rad) + 1.0) * 128), trunc((:math.sin(rad + 1) + 1.0) * 128), trunc((:math.sin(rad + 2) + 1.0) * 128)]
        else
          [0, 0, 0]
        end
      end)
    end)
    Python.call(:"sense.set_pixels", [cells])
    loop(rad + 0.01)
  end
end
