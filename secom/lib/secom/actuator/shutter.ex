defmodule Secom.Actuator.Shutter do
  use ContextEX
  @shutter :shutter_pid

  def start() do
    IO.inspect "shutter0"
    Process.register(self(), @shutter)
    loop()
  end

  deflf update(), %{:status => :emergency} do
    send Process.whereis(@shutter), :on
  end

  deflf update() do
    send Process.whereis(@shutter), :off
  end

  defp loop() do
    try do
      receive do
        :on -> IO.puts Process.group_leader(), "shutter closed"# close shutter
        :off -> :none# open shutter
      end
    catch
      _, e -> IO.puts Process.group_leader(), "error: #{inspect e}"
        IO.puts Process.group_leader(), "まだ起動してない"
    end
    loop()
  end
end
