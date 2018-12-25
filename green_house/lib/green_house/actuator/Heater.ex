defmodule GreenHouse.Sensor.Heater do
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
      :off -> IO.puts "heater deactivated"
    end
  end
end
