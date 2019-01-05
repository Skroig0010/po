defmodule GreenHouse.Actuator.Heater do
  use ContextEX
  @heater :heater_pid

  def start() do
    IO.puts "start heater"
    Process.register(self(), @heater)
    loop(:off)
  end

  deflf update(), %{:state => :cold} do
    send Process.whereis(@heater), :on
  end

  deflf update() do
    send Process.whereis(@heater), :off
  end

  def loop(switch) do
    loop(receive do
      :on -> 
        if(switch !== :on) do
          IO.puts "heater activated"
        end
        Python.call(:"sense.set_pixel", [7, 0, 255, 0, 0])
        :on
      :off -> 
        if(switch !== :off) do
          IO.puts "heater deactivated"
        end
        Python.call(:"sense.set_pixel", [7, 0, 0, 0, 0])
        :off
    end)
  end
end
