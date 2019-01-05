defmodule GreenHouse.Sensor.Thermometer do
  def start(pid) do
    IO.inspect "start thermometer"
    loop(pid)
  end
  def loop(pid) do
    try do
      {up, _, _, _} = GreenHouse.Joystick.get_direction()
      t = if(up) do
        50
      else
        30
      end
      send pid, %GreenHouse.Event{type: :thermometer, value: t}
      IO.puts "thermometer"  <> ":" <> Atom.to_string(node()) <> ":" <> Integer.to_string(t)
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
