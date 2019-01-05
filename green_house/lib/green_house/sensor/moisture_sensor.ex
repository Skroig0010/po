defmodule GreenHouse.Sensor.MoistureSensor do
  def start(pid) do
    IO.inspect "start moisture sensor"
    loop(pid)
  end
  def loop(pid) do
    try do
      {_, down, _, _} = GreenHouse.Joystick.get_direction()
      t = if(down) do
        1.2
      else
        0.5
      end
      send pid, %GreenHouse.Event{type: :moisture_sensor, value: t}
      IO.puts "moisture"  <> ":" <> Atom.to_string(node()) <> ":" <> Integer.to_string(t)
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
