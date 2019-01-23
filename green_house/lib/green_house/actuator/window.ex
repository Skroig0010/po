defmodule GreenHouse.Actuator.Window do
  use ContextEX
  @window :window_pid

  def start() do
    IO.puts "start window"
    Process.register(self(), @window)
    loop()
  end

  deflf update(), %{:temperature => :hot, :window => :deactuated} do
    cast_activate_layer(%{:window => :actuated})
    send Process.whereis(@window), :on
  end

  deflf update(), %{:temperature => temperature, :window => :actuated} when temperature != :hot do
    cast_activate_layer(%{:window => :deactuated})
    send Process.whereis(@window), :off
  end

  deflf update() do
  end

  def loop() do
    receive do
      :on -> 
        IO.puts "window activated"
        Python.call(:"sense.set_pixel", [3, 3, 255, 255, 255])
        Python.call(:"sense.set_pixel", [4, 3, 255, 255, 255])
        Python.call(:"sense.set_pixel", [3, 4, 255, 255, 255])
        Python.call(:"sense.set_pixel", [4, 4, 255, 255, 255])
      :off -> 
        IO.puts "window deactivated"
        Python.call(:"sense.set_pixel", [3, 3, 0, 0, 0])
        Python.call(:"sense.set_pixel", [4, 3, 0, 0, 0])
        Python.call(:"sense.set_pixel", [3, 4, 0, 0, 0])
        Python.call(:"sense.set_pixel", [4, 4, 0, 0, 0])
    end
    loop()
  end
end
