defmodule Secom.Sensor.HumanSensor do
  def start(pid) do
    IO.inspect "human 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      {_, _, left, _} = Secom.Joystick.get_direction()

      send pid, %Secom.Event{type: :human, value: left}
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
