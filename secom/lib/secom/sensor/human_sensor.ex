defmodule Secom.Sensor.HumanSensor do
  def start(pid) do
    IO.inspect "human 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      [_acton, direction] = Python.call(:wait_for_event, [])
      send pid, %Secom.Event{type: :human, value: (direction == 'left')}
      :timer.sleep(200)
      IO.puts "human_sensor"
      IO.inspect node()
      IO.inspect direction
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
