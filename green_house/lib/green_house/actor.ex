defmodule GreenHouse.Actor do
  def start([humidifier, heater, fan, window]) do
    Python.init()
    init_context(:actor)
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

  deflfp receive_msg(%GreenHouse.Event{type: :thermometer, value: val}), %{:month => month} when month >= 9 or month < 4 do

  end

end