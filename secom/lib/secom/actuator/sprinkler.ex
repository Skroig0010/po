defmodule Secom.Actuator.Sprinkler do
  use ContextEX
  @sprinkler :sprinkler_pid

  def start() do
    IO.inspect "sprinkler0"
    Process.register(self(), @sprinkler)
    loop()
  end

  deflf update(), %{:status => :emergency} do
    send Process.whereis(@sprinkler), :on
  end

  deflf update() do
    send Process.whereis(@sprinkler), :off
  end

  defp loop() do
    try do
      receive do
        :on -> "sprinkler actuated"# actuate sprinkler
        :off -> :none# deactuate sprinkler
      end
    catch
      _, e -> IO.puts Process.whereis(:iex), "error: #{inspect e}"
        IO.puts Process.whereis(:iex), "まだ起動してない"
    end
    loop()
  end
end
