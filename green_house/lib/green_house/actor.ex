defmodule GreenHouse.Actor do
  use ContextEX
  def start(id) do
    Python.init()
    init_context([:actor, id])
    loop(id)
  end


  def loop(id) do
    try do
      receive do
        msg ->
          receive_msg(id, msg)
      end

      GreenHouse.Actuator.FanSystem.update()
      GreenHouse.Actuator.Heater.update()
      GreenHouse.Actuator.Humidifier.update()
      GreenHouse.Actuator.Window.update()
      # WindSensor
      # RainSensor
      # SoilTemperatureSensor
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop(id)
  end

  # 季節ごとに設定温度を変える
  # 得たデータはsinkノードに送りgroupのコンテキスト変更はsinkノードにやってもらう
  deflfp receive_msg(id, %GreenHouse.Event{type: :thermometer, value: val}), %{:month => month} when month >= 9 or month < 4 do
    if(val < 5) do
      cast_activate_group(:sink, %{id => :cold})
    else
      cast_activate_group(:sink, %{id => :normal})
    end
  end

  deflfp receive_msg(id, %GreenHouse.Event{type: :thermometer, value: val}), %{:month => month} when month >= 9 or month < 4 do
    if(val > 28) do
      cast_activate_group(:sink, %{id => :hot})
    else
      cast_activate_group(:sink, %{id => :normal})
    end
  end

  deflfp receive_msg(id, %GreenHouse.Event{type: :moisture_sensor, value: val}) do
  end

end
