defmodule Secom.Sensor.SmokeSensor do
  def start(pid) do
    IO.inspect "smoke 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      event_list = Python.call(:get_events, [])
      
      [_action, direction] = if (length(event_list) > 0) do
        hd(event_list)
      else
        ['released', 'middle']
      end

      send pid, %Secom.Event{type: :smoke, value: (direction == 'down')}
      :timer.sleep(500)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
