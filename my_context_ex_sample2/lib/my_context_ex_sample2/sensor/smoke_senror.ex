defmodule MyContextExSample2.Sensor.SmokeSensor do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    try do
      raw = Python.call(:get_accelerometer_raw, [])
      send pid, %Event{type: :smoke, value: hd(raw) > 40}
      :timer.sleep(1000)
      IO.inspect raw;
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop(pid)
  end
end
