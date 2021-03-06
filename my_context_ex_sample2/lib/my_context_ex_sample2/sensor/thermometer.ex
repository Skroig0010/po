defmodule MyContextExSample2.Sensor.Thermometer do
  def start(pid) do
    IO.inspect "thermo 0"
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
        IO.puts "まだ起動してない"
    end
    loop(pid)
  end
end
