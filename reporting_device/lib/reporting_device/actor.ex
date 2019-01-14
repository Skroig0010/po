defmodule ReportingDevice.Actor do
  use ContextEX

  def start(is_sink) do
    Python.init()
    ReportingDevice.Joystick.init()
    init_context(if(is_sink) do
      :sink
    else
      nil
    end)
    loop()
  end

  deflf loop() do
    try do
      receive do
        msg ->
          receive_msg(msg)
      end

      ReportingDevice.Joystick.update()
      ReportingDevice.Actuator.ReportingDevice.update()
      ReportingDevice.Actuator.Display.update()
    catch
      x, e -> IO.puts "error at actor loop: #{inspect e} : #{inspect x}"
    end
    loop()
  end

  # human sensor
  deflfp receive_msg(%ReportingDevice.Event{type: :human, value: val}), %{:time => time} when val == true and (time > 23 or time < 5) do
    cast_activate_layer(%{:suspicious_person => true})
  end

  deflfp receive_msg(%ReportingDevice.Event{type: :human, value: _}) do
    cast_activate_layer(%{:suspicious_person => false})
  end

  # default method
  deflfp receive_msg(msg) do
    IO.puts "there is no function for the following message:#{inspect msg}"
  end
end
