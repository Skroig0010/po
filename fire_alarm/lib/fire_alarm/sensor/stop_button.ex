defmodule FireAlarm.Sensor.StopButton do
  def start(pid) do
    IO.inspect "button 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      action = FireAlarm.Joystick.get_action()

      t = (action == :pressed)
      send pid, %FireAlarm.Event{type: :stop_button, value: t}
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
