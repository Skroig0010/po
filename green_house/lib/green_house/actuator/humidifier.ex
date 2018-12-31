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
      :off -> IO.puts "Humidifier deactivated"
    end
  end
end
