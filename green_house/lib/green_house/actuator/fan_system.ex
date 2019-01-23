defmodule GreenHouse.Actuator.FanSystem do
  use ContextEX
  @fan_system :fan_system_pid

  def start() do
    IO.puts "start fan system"
    Process.register(self(), @fan_system)
    loop()
  end

  # 温度差がある場合はファンを回す
  deflf update(), %{:temperature_diff => true, :fan_system => :deactuated} do
    cast_activate_layer(%{:fan_system => :actuated})
    send Process.whereis(@fan_system), :on
  end

  deflf update(), %{:temperature_diff => false, :fan_system => :actuated} do
    cast_activate_layer(%{:fan_system => :deactuated})
    send Process.whereis(@fan_system), :off
  end

  deflf update() do
  end

  def loop() do
    receive do
      :on -> 
        IO.puts "fan system activated"
        Python.call(:"sense.set_pixel", [0, 0, 0, 0, 255])
      :off -> 
        IO.puts "fan system deactivated"
        Python.call(:"sense.set_pixel", [0, 0, 0, 0, 0])
    end
    loop()
  end
end
