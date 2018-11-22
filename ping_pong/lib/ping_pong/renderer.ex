defmodule PingPong.Renderer do
  @w [255,255,255]
  @b [0,0,0]
  @black_screen [@b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b,
                 @b, @b, @b, @b, @b, @b, @b, @b]
  @spec start() :: no_return
  def start() do
    loop(@black_screen, 0)
  end

  @spec loop([[integer]], integer) :: no_return
  defp loop(display, drawned) do
    if(drawned == 1) do
      Python.call(:"sense.set_pixels", [display])
      loop(@black_screen, 0)
    else
      receive do
        :update -> send(Process.whereis(:bar), {:get_position, self()})
          loop(@black_screen, 0)
        {:bar, x, y} -> List.update_at(display, y*8 + x, fn _ -> @w end)
          loop(display, drawned + 1)
      end
    end
  end
end
