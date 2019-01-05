defmodule GreenHouse.Actuator.Humidifier do
  use ContextEX
  @humidifier :humidifier_pid

  def start() do
    IO.puts "start humidifier"
    Process.register(self(), @humidifier)
    loop(:off)
  end

  deflf update(), %{:humidity => :low} do
    send Process.whereis(@humidifier), :on
  end

  deflf update() do
    send Process.whereis(@humidifier), :off
  end

  def loop(switch) do
    loop(receive do
      :on ->
        if(switch !== :on) do
          IO.puts "Humidifier activated"
        end
        Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
        :on
      :off -> 
        if(switch !== :off) do
          IO.puts "Humidifier deactivated"
        end
        Python.call(:"sense.set_pixel", [0, 7, 0, 0, 0])
        :off
    end)
  end
end
