defmodule PingPong.Entity.Bar do
  @initial_x 2
  @initial_y 4

  @spec start() :: no_return
  def start() do
    loop(@initial_x, @initial_y, %PingPong.Entity.KeyState{})
  end

  @spec loop(integer,integer, PingPong.Entity.KeyState.t()) :: no_return
  defp loop(x, y, key_state) do
    receive do
      [_action, direction]  when is_atom(direction) ->
          loop(x, y, Map.update!(key_state, direction, fn _ -> true end))

      :update -> 
        x = cond do
          key_state.left -> max(x - 1, 0)
          key_state.right -> min(x + 1, Application.get_env(:ping_pong, :field_width) - Application.get_env(:ping_pong, :bar_width))
          true -> x
        end

        y = cond do
          key_state.up -> max(y - 1, 0)
          key_state.down -> min(y + 1, Application.get_env(:ping_pong, :field_height) - Application.get_env(:ping_pong, :bar_height))
          true -> y
        end

        loop(x, y, %PingPong.Entity.KeyState{})
      {:get_position, pid} -> send pid, {:bar, x, y}
        loop(x, y, key_state)
      :kill -> nil
    end
  end
end
