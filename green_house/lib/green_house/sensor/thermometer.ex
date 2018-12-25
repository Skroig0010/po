defmodule GreenHouse.Sensor.Thermometer do
  def start(pid) do
    IO.inspect "start thermometer"
    loop(pid)
  end
  def loop(pid) do
    try do
      [_acton, direction] = Python.call(:wait_for_event, [])
      t = if(direction == 'up') do
        50
      else
        30
      end
      send pid, %Secom.Event{type: :thermometer, value: t}
      IO.puts "thermometer"  <> ":" <> Atom.to_string(node()) <> ":" <> Integer.to_string(t)
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
