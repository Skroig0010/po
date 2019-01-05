defmodule GreenHouse.Sensor.HumiditySensor do
  def start(pid) do
    IO.inspect "start humidity sensor"
    loop(pid)
  end
  def loop(pid) do
    try do
      {_, _, left, _} = GreenHouse.Joystick.get_direction()
      t = if(left) do
        0.2
      else
        0.7
      end
      send pid, %GreenHouse.Event{type: :humidity_sensor, value: t}
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
