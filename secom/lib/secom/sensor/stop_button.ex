defmodule Secom.Sensor.StopButton do
  def start(pid) do
    IO.inspect "button 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      event_list = Python.call(:get_events, [])
      
      [action, _direction] = if (length(event_list) > 0) do
        hd(event_list)
      else
        ['released', 'middle']
      end

      t = (action == 'pressed')
      send pid, %Secom.Event{type: :stop_button, value: t}
      :timer.sleep(500)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
