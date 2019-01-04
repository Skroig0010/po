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
      IO.puts self(), "human_sensor updated"
      IO.inspect node()
      IO.inspect direction
    catch
      _, e -> IO.puts self(), "error: #{inspect e}"
        IO.puts self(), "まだ起動してない"
    end
    loop(pid)
  end
end
