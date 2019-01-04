defmodule Secom.Sensor.StopButton do
  def start(pid) do
    IO.inspect "button 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      [action, _direction] = Python.call(:wait_for_event, [])
      t = (action == 'pressed')
      send pid, %Secom.Event{type: :stop_button, value: t}
      IO.puts self(), "stop_button updated"
      IO.inspect node()
      IO.inspect t
      :timer.sleep(200)
    catch
      _, e -> IO.puts self(), "error: #{inspect e}"
        IO.puts self(), "まだ起動してない"
    end
    loop(pid)
  end
end
