defmodule GreenHouse.Actuator.FanSystem do
  use ContextEX
  @fan_system :fan_system_pid

  def start() do
    IO.puts "start fan system"
    Process.register(self(), @fan_system)
    loop(:off)
  end

  # 温度差がある場合はファンを回す
  deflf update(), %{:temperature_diff => true} do
    send Process.whereis(@fan_system), :on
  end

  deflf update() do
    send Process.whereis(@fan_system), :off
  end

  def loop(switch) do
    loop(receive do
      :on -> 
        if(switch !== :on) do
          IO.puts "fan system activated"
        end
        Python.call(:"sense.set_pixel", [0, 0, 0, 0, 255])
        :on
      :off -> 
        if(switch !== :off) do
          IO.puts "fan system deactivated"
        end
        Python.call(:"sense.set_pixel", [0, 0, 0, 0, 0])
        :off
    end)
  end
end
