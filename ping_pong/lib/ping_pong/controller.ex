defmodule PingPong.Controller do
  def start() do
    loop(:released, :middle)
  end

  def loop(action, direction) do
    receive do
      [new_action, new_direction] -> loop(new_action, new_direction)
      pid -> send(pid, [action, direction])
        loop(action, direction)
      _ -> loop(action, direction)
    end
  end
end
