defmodule GreenHouse.Sensor.MoistureSensor do
  def start(pid) do
    IO.puts "start moisture sensor"
    loop(pid)
  end
  def loop(pid) do
    try do
      {_, _, _, right} = GreenHouse.Joystick.get_direction()
      t = if(right) do
        0.5
      else
        1.0
      end
      send pid, %GreenHouse.Event{type: :moisture_sensor, value: t}
      :timer.sleep(1000)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
