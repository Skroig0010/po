defmodule GreenHouse.Sensor.FanSystem do
  use ContextEX
  @fan_system :fan_system_pid

  def start() do
    IO.puts "start fan system"
    Process.register(self(), @fan_system)
    loop()
  end

  # 温度差がある場合はファンを回す
  deflf update(from_ids, to_ids), %{:temperature_diff => true} do
    send Process.whereis(@fan_system), :on
  end

  deflf update(_ids) do
    send Process.whereis(@fan_system), :off
  end

  def loop() do
    receive do
      :on -> IO.puts "fan system activated"
      :off -> IO.puts "fan system deactivated"
    end
  end
end
