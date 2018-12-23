defmodule Secom.Actuator.Shutter do
  use ContextEX
  @shutter :shutter_pid
  def start() do
    IO.inspect "shutter0"
    loop()
  end

  deflf update(), %{:state => :fire} do
    send Process.whereis(@shutter), :on
  end

  deflf update() do
    send Process.whereis(@shutter), :off
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
