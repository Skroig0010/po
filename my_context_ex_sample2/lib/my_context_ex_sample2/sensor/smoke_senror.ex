defmodule MyContextExSample2.Sensor.SmokeSensor do
  def start(pid) do
    IO.inspect "smoke 0"
    loop(pid)
  end
  def loop(pid) do
    try do
      raw = Python.call(:get_accelerometer_raw, [])
      send pid, %Event{type: :smoke, value: hd(raw) > 0}
      :timer.sleep(200)
      IO.inspect raw
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
