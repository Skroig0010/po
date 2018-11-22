defmodule PingPong.Controller do
  def start() do
    loop(:released, :middle)
  end

  defp loop(action, direction) do
    receive do
      [new_action, new_direction] ->
        loop(new_action, new_direction)

      pid when is_pid(pid) ->
        send(pid, [action, direction])
        loop(action, direction)
    end
  end
end
