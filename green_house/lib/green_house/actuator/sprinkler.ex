defmodule GreenHouse.Actuator.Sprinkler do
  use ContextEX
  @sprinkler :sprinkler_pid

  def start() do
    IO.puts "start sprinkler"
    Process.register(self(), @sprinkler)
    loop(:off)
  end

  deflf update(), %{:soil_moisture => :low} do
    send Process.whereis(@sprinkler), :on
  end

  deflf update() do
    send Process.whereis(@sprinkler), :off
  end

  def loop(switch) do
    loop(receive do
      :on -> 
        if(switch !== :on) do
          IO.puts "Sprinkler activated"
        end
        Python.call(:"sense.set_pixel", [7, 7, 0, 255, 255])
        :on
      :off ->
        if(switch !== :off) do
          IO.puts "Sprinkler deactivated"
        end
        Python.call(:"sense.set_pixel", [7, 7, 0, 0, 0])
        :off
    end)
  end
end
