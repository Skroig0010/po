defmodule PingPong.Sensor.Controller do
  @spec start(pid :: pid) :: none
  def start(pid) do
    loop(pid)
  end

  @spec loop(pid :: pid) :: none
  def loop(pid) do
    try do
      input = Python.call(:wait_for_event, [])
      send pid, %PingPong.KeyEvent{value: input}
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop(pid)
  end
end
