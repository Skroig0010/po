defmodule Secom.Actuator.ReportingDevice do
  use ContextEX
  @reporter :reporting_device_pid
  def start() do
    IO.inspect "report0"
    Process.register(self(), @reporter)
    loop()
  end

  deflf update(), %{:suspisious_person => true, :reporting => :done} do
  end

  deflf update(), %{:suspisious_person => true} do
    send Process.whereis(@reporter), :on
    cast_activate_layer(%{:reporting => :done})
  end

  deflf update() do
    cast_activate_layer(%{:reporting => :not_reported})
  end

  defp loop() do
    try do
      receive do
        :on -> IO.puts "reporting suspisious person"# close shutter
        :off -> :none# open shutter
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop()
  end
end
