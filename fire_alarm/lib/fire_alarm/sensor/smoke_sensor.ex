defmodule FireAlarm.Sensor.SmokeSensor do
  def start(pid) do
    IO.inspect "smoke 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      {_, down, _, _} = FireAlarm.Joystick.get_direction()

      send pid, %FireAlarm.Event{type: :smoke, value: down}
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
