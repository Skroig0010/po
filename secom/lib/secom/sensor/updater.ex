defmodule Secom.Sensor.Updater do
  def start(pid) do
    IO.inspect "updater 0"
    loop(pid, 0)
  end

  def loop(pid, count) do
    send pid, %Secom.Event{type: :updater, value: count}
    :timer.sleep(1000)
    loop(pid, count+1)
  end
end
