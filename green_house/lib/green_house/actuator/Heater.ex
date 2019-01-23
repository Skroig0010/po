defmodule GreenHouse.Actuator.Heater do
  use ContextEX
  @heater :heater_pid

  def start() do
    IO.puts "start heater"
    Process.register(self(), @heater)
    loop()
  end

  deflf update(), %{:temperature => :cold, :heater => :deactuated} do
    cast_activate_layer(%{:heater => :actuated})
    send Process.whereis(@heater), :on
  end

  deflf update(), %{:temperature => temperature, :heater => :actuated} when temperature != :cold do
    cast_activate_layer(%{:heater => :deactuated})
    send Process.whereis(@heater), :off
  end

  deflf update() do
  end

  def loop() do
    receive do
      :on -> 
        IO.puts "heater activated"
        Python.call(:"sense.set_pixel", [7, 0, 255, 0, 0])
      :off -> 
        IO.puts "heater deactivated"
        Python.call(:"sense.set_pixel", [7, 0, 0, 0, 0])
    end
    loop()
  end
end
