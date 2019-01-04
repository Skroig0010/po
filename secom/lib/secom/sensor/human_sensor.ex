defmodule Secom.Sensor.HumanSensor do
  def start(pid) do
    IO.inspect "human 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      [_action, direction] = Python.call(:wait_for_event, [])
      send pid, %Secom.Event{type: :human, value: (direction == 'left')}
      :timer.sleep(200)
      IO.puts Process.whereis(:iex), "human_sensor updated"
      IO.puts Process.whereis(:iex), "node:#{inspect node()}, #{inspect direction}"
    catch
      _, e -> IO.puts Process.whereis(:iex), "error: #{inspect e}"
        IO.puts Process.whereis(:iex), "まだ起動してない"
    end
    loop(pid)
  end
end
