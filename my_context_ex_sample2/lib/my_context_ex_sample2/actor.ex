defmodule MyContextExSample2.Actor do
  use ContextEX

  def start() do
    IO.inspect "0";
    Python.init()
    IO.inspect "1";
    init_context(:actor)
    loop()
  end


  deflf loop(), %{:status => :emergency} do
    Python.call(:"sense.show_message", ["emergency"])
    :timer.sleep(1000)
    loop()
  end

  deflf loop(), %{:temperature => :high, :smoke => true} do
    Python.call(:"sense.show_message", ["fire"])
    cast_activate_group(:actor, %{:status => :emergency})
    :timer.sleep(1000)
    loop()
  end

  deflf loop() do
    IO.inspect :loop_start
    receive do
      msg ->
        receive_msg(msg)
    end
    IO.inspect :loop_end
    loop()
  end

  defp receive_msg(%Event{type: :thermometer, value: val}) when val > 40 do
    IO.inspect 0
    IO.inspect val
    Python.call(:"sense.set_pixel", [0, 0, val, 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  defp receive_msg(%Event{type: :thermometer, value: val}) when val <= 40 do 
    IO.inspect 1
    IO.inspect val
    Python.call(:"sense.set_pixel", [0, 0, val, 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  defp receive_msg(%Event{type: :smoke, value: val}) when val == true do
    IO.inspect 2
    IO.inspect val
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  defp receive_msg(%Event{type: :smoke, value: val}) when val == false do 
    IO.inspect 3
    IO.inspect val
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  defp receive_msg(_msg) do
    IO.inspect 4
  end
end
