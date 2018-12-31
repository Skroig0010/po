defmodule GreenHouse.Actuator.Window do
  use ContextEX
  @window :window_pid

  def start() do
    IO.puts "start window"
    Process.register(self(), @window)
    loop()
  end

  deflf update(), %{:state => :hot} do
    send Process.whereis(@window), :on
  end

  deflf update() do
    send Process.whereis(@window), :off
  end

  def loop() do
    receive do
      :on -> IO.puts "window activated"
      :off -> IO.puts "window deactivated"
    end
  end
end
