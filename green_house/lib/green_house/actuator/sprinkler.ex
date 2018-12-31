defmodule GreenHouse.Actuator.Sprinkler do
  use ContextEX
  @sprinkler :sprinkler_pid

  def start() do
    IO.puts "start sprinkler"
    Process.register(self(), @sprinkler)
    loop()
  end

  deflf update(), %{:soil_moisture => :low} do
    send Process.whereis(@sprinkler), :on
  end

  deflf update() do
    send Process.whereis(@sprinkler), :off
  end

  def loop() do
    receive do
      :on -> IO.puts "Sprinkler activated"
        Python.call(:"sense.set_pixel", [7, 7, 0, 255, 255])
      :off -> IO.puts "Sprinkler deactivated"
        Python.call(:"sense.set_pixel", [7, 7, 0, 0, 0])
    end
  end
end
