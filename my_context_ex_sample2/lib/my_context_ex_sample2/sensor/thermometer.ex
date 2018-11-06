defmodule MyContextExSample2.Sensor.Thermometer do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    try do
      t = Python.call(:"sense.get_temperature", [])
      send pid, %Event{type: :thermometer, value: t}
      IO.inspect t
      :timer.sleep(200)
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop(pid)
  end
end
