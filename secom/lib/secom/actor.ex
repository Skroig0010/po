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

  defp receive_msg(%Secom.Event{type: :thermometer, value: val}) when val > 40 do
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  defp receive_msg(%Secom.Event{type: :thermometer, value: val}) when val <= 40 do 
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  defp receive_msg(%Secom.Event{type: :smoke, value: val}) when val == true do
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  defp receive_msg(%Secom.Event{type: :smoke, value: val}) when val == false do 
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  defp receive_msg(%Secom.Event{type: :updater, value: 0}) do 
    IO.inspect :updated
  end

  defp receive_msg(msg) do
    IO.puts "there is no function for this↓ message."
    IO.inspect msg
  end

end
