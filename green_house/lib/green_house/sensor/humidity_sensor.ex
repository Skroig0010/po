defmodule GreenHouse.Sensor.HumiditySensor do
  def start(pid) do
    IO.inspect "start humidity sensor"
    loop(pid)
  end
  def loop(pid) do
    try do
      [_acton, direction] = Python.call(:wait_for_event, [])
      t = if(direction == 'left') do
        0.7
      else
        0.2
      end
      send pid, %GreenHouse.Event{type: :humidity_sensor, value: t}
      IO.puts "humidity"  <> ":" <> Atom.to_string(node()) <> ":" <> Integer.to_string(t)
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
