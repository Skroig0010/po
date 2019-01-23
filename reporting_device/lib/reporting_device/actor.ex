defmodule ReportingDevice.Actor do
  use ContextEX

  def start() do
    Python.init()
    init_context([:actor])
    loop()
  end

  def loop() do
    try do
      receive do
        msg ->
          receive_msg(msg)
      end

      ReportingDevice.Actuator.Display.update()
    catch
      x, e -> IO.puts "error at actor loop: #{inspect e} : #{inspect x}"
    end
    loop()
  end

  # human sensor
  deflfp receive_msg(%ReportingDevice.Event{type: :human, value: true}), %{:time => time} when (time > 23 or time < 5) do
    Python.call(:"sense.set_pixel", [0, 3, 255, 255, 255])
    cast_activate_group(:sink, %{:suspicious_person => true})
    cast_activate_layer(%{:suspicious_person => true})
  end

  deflfp receive_msg(%ReportingDevice.Event{type: :human, value: false}), %{:suspicious_person => true} do
    Python.call(:"sense.set_pixel", [0, 3, 0, 0, 0])
    cast_activate_group(:sink, %{:suspicious_person => false})
    cast_activate_layer(%{:suspicious_person => false})
  end

  # 何もしない
  deflfp receive_msg(msg) do
  end
end
