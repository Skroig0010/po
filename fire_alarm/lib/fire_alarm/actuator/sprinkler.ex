defmodule FireAlarm.Actuator.Sprinkler do
  use ContextEX
  @sprinkler :sprinkler_pid

  def start() do
    IO.inspect "sprinkler0"
    Process.register(self(), @sprinkler)
    loop()
  end

  deflf update(), %{:status => :emergency, :sprinkler => :deactuated} do
    cast_activate_layer(%{:sprinkler => :actuated})
    send Process.whereis(@sprinkler), :on
  end

  deflf update(), %{:status => :normal, :sprinkler => :actuated} do
    cast_activate_layer(%{:sprinkler => :deactuated})
    send Process.whereis(@sprinkler), :off
  end

  deflf update() do
  end

  defp loop() do
    try do
      receive do
        :on -> IO.puts "sprinkler actuated"# actuate sprinkler
        :off -> :none# deactuate sprinkler
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop()
  end
end
