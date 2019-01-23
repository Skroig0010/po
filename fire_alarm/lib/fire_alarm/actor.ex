defmodule FireAlarm.Actor do
  use ContextEX

  @spec get_floor_atom(integer) :: atom
  defp get_floor_atom(floor) do
    String.to_atom("floor" <> Integer.to_string(floor))
  end

  def start(floor) do
    Python.init()
    FireAlarm.Joystick.init()
    init_context([:actor, get_floor_atom(floor)])
    loop(floor)
  end

  deflf loop(floor), %{:temperature => :high, :smoke => true, :status => status} when status !== :emergency do
    cast_activate_group(get_floor_atom(floor), %{:status => :emergency})
    loop(floor)
  end

  deflf loop(floor) do
    try do
      receive do
        msg ->
          receive_msg(msg)
      end

      FireAlarm.Joystick.update()
      FireAlarm.Actuator.Sprinkler.update()
      FireAlarm.Actuator.Shutter.update()
      FireAlarm.Actuator.Display.update()
    catch
      x, e -> IO.puts "error at actor loop: #{inspect e} : #{inspect x}"
    end
    loop(floor)
  end

  # thermometer
  defp receive_msg(%FireAlarm.Event{type: :thermometer, value: val}) when val > 40 do
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 0, 255])
    cast_activate_layer(%{:temperature => :high}) 
  end

  defp receive_msg(%FireAlarm.Event{type: :thermometer, value: val}) when val <= 40 do 
    Python.call(:"sense.set_pixel", [0, 0, rem(trunc(val * 100), 255), 255, 255])
    cast_activate_layer(%{:temperature => :normal})
  end

  # smoke sensor
  defp receive_msg(%FireAlarm.Event{type: :smoke, value: val}) when val == true do
    Python.call(:"sense.set_pixel", [0, 7, 255, 0, 255])
    cast_activate_layer(%{:smoke => true}) 
  end

  defp receive_msg(%FireAlarm.Event{type: :smoke, value: val}) when val == false do 
    Python.call(:"sense.set_pixel", [0, 7, 0, 255, 255])
    cast_activate_layer(%{:smoke => false})
  end

  # updater
  # センサーをjoystickで代用してるのでjoystickの入力がないとloop()が止まってしまい、コンテキスト変化に対応できない
  # ちゃんとしたセンサーを乗せたら必要なくなる
  defp receive_msg(%FireAlarm.Event{type: :updater, value: _val}) do 
    Python.call(:"sense.set_pixel", [3, 3, 255, 255, 255])
  end

  # スプリンクラー停止ボタン
  # 火事なのに止めちゃうと取り返しがつかない
  defp receive_msg(%FireAlarm.Event{type: :stop_button, value: true}) do
    cast_activate_group(:actor, %{:status => :normal})
  end

  defp receive_msg(%FireAlarm.Event{type: :stop_button, value: false}) do
    # 何もしない
  end

  # default method
  defp receive_msg(msg) do
    IO.puts "there is no function for the following message:#{inspect msg}"
  end
end
