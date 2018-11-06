defmodule MyContextExSample2.Sensor.Thermometer do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    try do
      IO.inspect "thermo0";
      t = Python.call(:"sense.get_temperature", [])
      send pid, %Event{type: :thermometer, value: t}
      :timer.sleep(1000)
      IO.inspect "thermo1";
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop(pid)
  end
end
