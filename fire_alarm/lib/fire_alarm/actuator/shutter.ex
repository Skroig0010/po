defmodule FireAlarm.Actuator.Shutter do
  use ContextEX
  @shutter :shutter_pid

  def start() do
    IO.inspect "shutter0"
    Process.register(self(), @shutter)
    loop()
  end

  deflf update(), %{:status => :emergency, :shutter => :deactuated} do
    cast_activate_layer(%{:shutter => :actuated})
    send Process.whereis(@shutter), :on
  end

  deflf update(), %{:status => :normal, :shutter => :actuated} do
    cast_activate_layer(%{:shutter => :deactuated})
    send Process.whereis(@shutter), :off
  end

  deflf update() do
  end

  defp loop() do
    try do
      receive do
        :on -> IO.puts "shutter closed"# close shutter
        :off -> :none# open shutter
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop()
  end
end
