defmodule ReportingDevice.Actuator.Display do
  use ContextEX
  @display :display_pid

  def start() do
    IO.inspect "display0"
    Process.register(self(), @display)
    loop("")
  end

  deflf update(), %{:suspicious_person => true} do
    pid = Process.whereis(@display)
    unless(pid === nil) do
      send pid, "reporting"
    end
  end

  deflf update(), %{:status => :emergency} do
    pid = Process.whereis(@display)
    unless(pid === nil) do
      send pid, "emergency"
    end
  end

  deflf update() do
    pid = Process.whereis(@display)
    unless(pid === nil) do
      send pid, ""
    end
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
