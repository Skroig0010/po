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
    loop(0.0, 0)
  end

  def loop(rad, color) do
    cells = Enum.flat_map(0..8, fn y ->
      Enum.flat_map(0..8, fn x ->
        if(y < (:math.sin(rad) + 1.0) * 4) do
          [color, 255 - color, color + 128]
        else
          [0, 0, 0]
        end
      end)
    end)
    Python.call(:"sense.set_pixels", cells)
  end
end
