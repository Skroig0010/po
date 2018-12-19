defmodule Secom.Actuator.ReportingDevice do
  def start() do
    IO.inspect "report0"
    loop()
  end
  def loop() do
    try do
      receive do
        :on -> :none# close shutter
        :off -> :none# open shutter
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop()
  end
end
