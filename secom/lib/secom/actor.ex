defmodule Secom.Actor do
  use ContextEX

  def start() do
    Python.init()
    init_context(:actor)
    loop()
  end


  deflf loop(), %{:status => :emergency} do
    Python.call(:"sense.show_message", ["emergency"])
    :timer.sleep(200)
    loop()
  end

  deflf loop(), %{:temperature => :high, :smoke => true} do
    Python.call(:"sense.show_message", ["fire"])
    cast_activate_group(:actor, %{:status => :emergency})
    :timer.sleep(200)
    loop()
  end

  deflf loop() do
    try do
      receive do
        msg ->
          receive_msg(msg)
      end
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop()
  end

  # thermometer
  deflfp receive_msg(%Secom.Event{type: :thermometer, value: val}), %{} when val > 40 do
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  deflfp receive_msg(%Secom.Event{type: :thermometer, value: val}), %{} when val <= 40 do 
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  # smoke sensor
  deflfp receive_msg(%Secom.Event{type: :smoke, value: val}), %{} when val == true do
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  deflfp receive_msg(%Secom.Event{type: :smoke, value: val}), %{} when val == false do 
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  # human sensor
  deflfp receive_msg(%Secom.Event{type: :human, value: val}), %{:time => time} when val == true and (time > 11 or time < 5) do
    Python.call(:"sense.set_pixel", [0, 3, 255, 255, 255])
    cast_activate_layer(%{:suspicious_person => true})
  end

  deflfp receive_msg(%Secom.Event{type: :human, value: _}) do
    Python.call(:"sense.set_pixel", [0, 3, 0, 0, 0])
    cast_activate_layer(%{:suspicious_person => false})
  end

  # updater
  deflfp receive_msg(%Secom.Event{type: :updater, value: 0}) do 
    Python.call(:"sense.set_pixel", [3, 3, 255, 255, 255])
  end

  # default method
  deflfp receive_msg(msg) do
    IO.puts "there is no function for the following message."
    IO.inspect msg
  end

end
