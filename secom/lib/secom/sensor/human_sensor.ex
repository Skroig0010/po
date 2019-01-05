defmodule Secom.Sensor.HumanSensor do
  def start(pid) do
    IO.inspect "human 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      event_list = Python.call(:get_events, [])
      IO.inspect event_list
      
      [_action, direction] = if (length(event_list) > 0) do
        hd(event_list)
      else
        ['released', 'middle']
      end

      send pid, %Secom.Event{type: :human, value: (direction == 'left')}
      :timer.sleep(200)
      IO.puts "human_sensor updated"
      IO.puts "node:#{inspect node()}, #{inspect direction}"
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
