defmodule GreenHouse.Actuator.Humidifier do
  use ContextEX
  @humidifier :humidifier_pid

  def start() do
    IO.puts "start humidifier"
    Process.register(self(), @humidifier)
    loop()
  end

  deflf update(), %{:humidity => :low} do
    send Process.whereis(@humidifier), :on
  end

  deflf update() do
    send Process.whereis(@humidifier), :off
  end

  def loop() do
    receive do
      :on -> IO.puts "Humidifier activated"
        Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
      :off -> IO.puts "Humidifier deactivated"
        Python.call(:"sense.set_pixel", [0, 7, 0, 0, 0])
    end
  end
end
