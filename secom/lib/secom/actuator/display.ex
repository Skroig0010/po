defmodule Secom.Actuator.Display do
  use ContextEX
  @display :display_pid

  def start() do
    IO.inspect "display0"
    Process.register(self(), @display)
    loop("")
  end

  deflf update(), %{:suspisious_person => true} do
    send Process.whereis(@display), "reporting suspicious person"
  end

  deflf update(), %{:status => :emergency} do
    send Process.whereis(@display), "emergency"
  end

  deflf update() do
    send Process.whereis(@display), ""
  end

  defp loop(sent_msg) do
    loop(receive do
      msg -> 
        unless(sent_msg == msg) do
          try do
            Python.call(:"sense.show_message", [msg])
          catch
            _, e -> IO.puts "error: #{inspect e}"
              IO.puts "まだ起動してない"
          end
        end
        msg
    end)
  end
end
