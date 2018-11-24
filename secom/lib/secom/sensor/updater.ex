defmodule Secom.Sensor.Updater do
  def start(pid) do
    IO.inspect "updater 0"
    loop(pid)
  end
  def loop(pid) do
    send pid, %Secom.Event{type: :updater, value: 0}
    :timer.sleep(1000)
    loop(pid)
  end
end
