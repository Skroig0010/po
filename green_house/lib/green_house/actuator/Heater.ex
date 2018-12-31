defmodule GreenHouse.Actuator.Heater do
  use ContextEX
  @heater :heater_pid

  def start() do
    IO.puts "start heater"
    Process.register(self(), @heater)
    loop()
  end

  deflf update(), %{:state => :cold} do
    send Process.whereis(@heater), :on
  end

  deflf update() do
    send Process.whereis(@heater), :off
  end

  def loop() do
    receive do
      :on -> IO.puts "heater activated"
        Python.call(:"sense.set_pixel", [7, 0, 255, 0, 0])
      :off -> IO.puts "heater deactivated"
        Python.call(:"sense.set_pixel", [7, 0, 0, 0, 0])
    end
  end
end
