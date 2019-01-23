defmodule GreenHouse.Actuator.Humidifier do
  use ContextEX
  @humidifier :humidifier_pid

  def start() do
    IO.puts "start humidifier"
    Process.register(self(), @humidifier)
    loop()
  end

  deflf update(), %{:humidity => :low, :humidifier => :deactuated} do
    cast_activate_layer(%{:humidifier => :actuated})
    send Process.whereis(@humidifier), :on
  end

  deflf update(), %{:humidity => :normal, :humidifier => :actuated} do
    cast_activate_layer(%{:humidifier => :deactuated})
    send Process.whereis(@humidifier), :off
  end

  deflf update() do
  end

  def loop() do
    receive do
      :on ->
        IO.puts "Humidifier activated"
        Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
      :off -> 
        IO.puts "Humidifier deactivated"
        Python.call(:"sense.set_pixel", [0, 7, 0, 0, 0])
    end
    loop()
  end
end
