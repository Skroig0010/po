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
    IO.inspect "2";
    receive do
      msg ->
        receive_msg(msg)
        IO.inspect msg
    end
    loop()
  end

  defp receive_msg(%Event{type: :thermometer, value: val}) when val > 40 do
    IO.inspect 0
    Python.call(:"sense.set_pixel", [0, 0, val, 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  defp receive_msg(%Event{type: :thermometer, value: val}) when val <= 40 do 
    IO.inspect 2
    Python.call(:"sense.set_pixel", [0, 0, val, 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  defp receive_msg(%Event{type: :smoke, value: val}) when val == true do
    IO.inspect 3
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  defp receive_msg(%Event{type: :smoke, value: val}) when val == false do 
    IO.inspect 4
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  defp receive_msg(_msg) do
    IO.inspect 5
  end
end
