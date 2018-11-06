defmodule MyContextExSample2.Sensor.SmokeSensor do
  def start(pid) do
    loop(pid)
  end
  def loop(pid) do
    raw = Python.call(:get_accelerometer_raw, [])
    
    send pid, %Event{type: :smoke, value: hd(raw) > 40}
    :timer.sleep(1000)
    loop(pid)
  end
end
