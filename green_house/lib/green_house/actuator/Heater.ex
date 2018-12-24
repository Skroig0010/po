defmodule GreenHouse.Sensor.Heater do
  use ContextEX

  def start() do
    IO.puts "start heater"
    Process.register(self(), @reporter)
    loop()
  end

  deflf update(), %{:state => :cold} do
  end
end
