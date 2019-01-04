defmodule Secom.Sensor.SmokeSensor do
  def start(pid) do
    IO.inspect "smoke 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      [_action, direction] = Python.call(:wait_for_event, [])
      send pid, %Secom.Event{type: :smoke, value: (direction == 'down')}
      :timer.sleep(200)
      IO.puts "smoke_sensor updated"
      IO.puts "node:#{inspect node()}, #{inspect direction}"
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
