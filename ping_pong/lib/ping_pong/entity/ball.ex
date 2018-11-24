defmodule PingPong.Entity.Ball do
  # 必要になったら作り、要らなくなったら捨てる
  @spec start(integer, integer, integer, integer) :: no_return
  def start(x, y, dx, dy) do
    loop(x, y, dx, dy)
  end

  @spec loop(integer,integer,integer,integer) :: no_return
  defp loop(x, y, vx, vy) do
    receive do
      :update ->
        loop(x + vx, y + vy, vx, vy)
      :collide_bar ->
        loop(x, y, vx, -1)
      {:get_position, pid} -> 
        send(pid, {:ball, x, y})
        loop(x, y, vx, vy)
      :kill -> nil
    end
  end


end
