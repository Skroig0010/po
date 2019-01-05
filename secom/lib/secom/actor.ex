defmodule Secom.Actor do
  use ContextEX

  @spec get_floor_atom(integer) :: atom
  defp get_floor_atom(floor) do
    String.to_atom("floor" <> Integer.to_string(floor))
  end

  def start(floor) do
    Python.init()
    Secom.Joystick.init()
    init_context([:actor, get_floor_atom(floor)])
    loop(floor)
    :timer.sleep(:infinity)
  end

  defp receive_and_actuate() do
    receive do
      msg ->
        receive_msg(msg)
    end

    Secom.Joystick.update()
    Secom.Actuator.Sprinkler.update()
    Secom.Actuator.Shutter.update()
    Secom.Actuator.ReportingDevice.update()
    Secom.Actuator.Display.update()
  end

  deflf loop(floor), %{:suspicious_person => true} do
    loop(floor)
  end

  deflf loop(floor), %{:status => :emergency} do
    try do
      receive_and_actuate()
    catch
      x, e -> IO.puts "error on actor emergency loop: #{inspect e} : #{inspect x}"
    end
    loop(floor)
  end

  deflf loop(floor), %{:temperature => :high, :smoke => true} do
    cast_activate_group(get_floor_atom(floor), %{:status => :emergency})
    loop(floor)
  end

  deflf loop(floor) do
    try do
      receive_and_actuate()
    catch
      x, e -> IO.puts "error on actor loop: #{inspect e} : #{inspect x}"
    end
    loop(floor)
  end

  # thermometer
  deflfp receive_msg(%Secom.Event{type: :thermometer, value: val}) when val > 40 do
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  deflfp receive_msg(%Secom.Event{type: :thermometer, value: val}) when val <= 40 do 
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  # smoke sensor
  deflfp receive_msg(%Secom.Event{type: :smoke, value: val}) when val == true do
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  deflfp receive_msg(%Secom.Event{type: :smoke, value: val}) when val == false do 
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  # human sensor
  deflfp receive_msg(%Secom.Event{type: :human, value: val}), %{:time => time} when val == true and (time > 23 or time < 5) do
    Python.call(:"sense.set_pixel", [0, 3, 255, 255, 255])
    cast_activate_layer(%{:suspicious_person => true})
  end

  deflfp receive_msg(%Secom.Event{type: :human, value: _}) do
    Python.call(:"sense.set_pixel", [0, 3, 0, 0, 0])
    cast_activate_layer(%{:suspicious_person => false})
  end

  # updater
  # センサーをjoystickで代用してるのでjoystickの入力がないとloop()が止まってしまい、コンテキスト変化に対応できない
  # ちゃんとしたセンサーを乗せたら必要なくなる
  deflfp receive_msg(%Secom.Event{type: :updater, value: _val}) do 
    Python.call(:"sense.set_pixel", [3, 3, 255, 255, 255])
  end

  # スプリンクラー停止ボタン
  # 火事なのに止めちゃうと取り返しがつかない
  deflfp receive_msg(%Secom.Event{type: :stop_button, value: true}) do
    cast_activate_group(:actor, %{:status => :normal})
  end

  deflfp receive_msg(%Secom.Event{type: :stop_button, value: false}) do
    # 何もしない
  end

  # default method
  deflfp receive_msg(msg) do
    IO.puts "there is no function for the following message:#{inspect msg}"
  end
end
