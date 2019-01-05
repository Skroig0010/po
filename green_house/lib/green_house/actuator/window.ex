defmodule GreenHouse.Actuator.Window do
  use ContextEX
  @window :window_pid

  def start() do
    IO.puts "start window"
    Process.register(self(), @window)
    loop(:off)
  end

  deflf update(), %{:state => :hot} do
    send Process.whereis(@window), :on
  end

  deflf update() do
    send Process.whereis(@window), :off
  end

  def loop(switch) do
    loop(receive do
      :on -> 
        if(switch !== :on) do
          IO.puts "window activated"
        end
        Python.call(:"sense.set_pixel", [3, 3, 255, 255, 255])
        Python.call(:"sense.set_pixel", [4, 3, 255, 255, 255])
        Python.call(:"sense.set_pixel", [3, 4, 255, 255, 255])
        Python.call(:"sense.set_pixel", [4, 4, 255, 255, 255])
        :on
      :off -> 
        if(switch !== :off) do
          IO.puts "window deactivated"
        end
        Python.call(:"sense.set_pixel", [3, 3, 0, 0, 0])
        Python.call(:"sense.set_pixel", [4, 3, 0, 0, 0])
        Python.call(:"sense.set_pixel", [3, 4, 0, 0, 0])
        Python.call(:"sense.set_pixel", [4, 4, 0, 0, 0])
        :off
    end)
  end
end
