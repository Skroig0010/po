defmodule MyContextExSample2.Sensor.Thermometer do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    t = Python.call(:"sense.get_temperature", [])
    send pid, %Event{type: :thermometer, value: t}
    :timer.sleep(1000)
    loop(pid)
  end
end
