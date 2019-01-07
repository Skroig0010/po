defmodule GreenHouse.Sensor.Thermometer do
  def start(pid) do
    IO.inspect "start thermometer"
    loop(pid)
  end
  def loop(pid) do
    try do
      {up, down, _, _} = GreenHouse.Joystick.get_direction()
      t = cond do
        up -> 50
        down -> 4
        true -> 27
      end
      send pid, %GreenHouse.Event{type: :thermometer, value: t}
      :timer.sleep(1000)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
