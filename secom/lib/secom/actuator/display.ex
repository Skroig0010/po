defmodule Secom.Actuator.Display do
  use ContextEX
  @display :display_pid

  def start() do
    IO.inspect "display0"
    Process.register(self(), @display)
    loop()
  end

  deflf update(), %{:suspisious_person => true} do
    send Process.whereis(@display), "reporting suspicious person"
  end

  deflf update(), %{:status => :emergency} do
    send Process.whereis(@display), "emergency"
  end

  deflf update() do
  end

  defp loop() do
    try do
      receive do
        msg -> Python.call(:"sense.show_message", [msg])
      end
    catch
      _, e -> IO.puts self(), "error: #{inspect e}"
        IO.puts self(), "まだ起動してない"
    end
    loop()
  end
end
