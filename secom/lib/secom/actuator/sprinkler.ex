defmodule Secom.Actuator.Sprinkler do
  def start() do
    IO.inspect "sprinkler0"
    loop()
  end
  def loop() do
    try do
      receive do
        :on -> :none# actuate sprinkler
        :off -> :none# deactuate sprinkler
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
        IO.puts "まだ起動してない"
    end
    loop()
  end
end
