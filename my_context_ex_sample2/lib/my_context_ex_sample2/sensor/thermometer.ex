defmodule MyContextExSample2.Sensor.Thermometer do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    IO.inspect "thermo0";
    t = Python.call(:"sense.get_temperature", [])
    send pid, %Event{type: :thermometer, value: t}
    :timer.sleep(1000)
    IO.inspect "thermo1";
    loop(pid)
  end
end
