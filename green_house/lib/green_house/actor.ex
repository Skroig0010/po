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
      GreenHouse.Actuator.Sprinkler.update()
      # WindSensor
      # RainSensor
      # SoilTemperatureSensor
    catch
      _, e -> IO.puts "error at actor loop: #{inspect e}"
    end
    loop(id)
  end

  # 季節ごとに設定温度を変える
  # 得たデータはsinkノードに送りgroupのコンテキスト変更はsinkノードにやってもらう
  deflfp receive_msg(id, %GreenHouse.Event{type: :thermometer, value: val}), %{:month => month} when month >= 9 or month < 4 do
    if(val < 5) do
      cast_activate_group(:sink, %{id => :cold})
      # ヒーターあるなら付ける
      cast_activate_layer(%{:state => :cold})
    else
      cast_activate_group(:sink, %{id => :normal})
    end
  end

  # 以下は春、夏
  deflfp receive_msg(id, %GreenHouse.Event{type: :thermometer, value: val}) when val > 28 do
    if(val > 30) do
      # 30℃を超えたら全ての窓を開ける
      cast_activate_group(:actor, %{:state => :hot})
    end
    cast_activate_group(:sink, %{id => :hot})
  end

  deflfp receive_msg(id, %GreenHouse.Event{type: :thermometer, value: val}) do
    if(val < 25) do
      # 25℃未満なら全ての窓を閉める
      cast_activate_group(:actor, %{:state => :normal})
    end
    cast_activate_group(:sink, %{id => :normal})
  end

  deflfp receive_msg(_id, %GreenHouse.Event{type: :moisture_sensor, value: val}) when val < 0.6 do
    cast_activate_layer(%{:soil_moisture => :low})
  end

  deflfp receive_msg(_id, %GreenHouse.Event{type: :moisture_sensor, value: _val}) do
    cast_activate_layer(%{:soil_moisture => :normal})
  end

  deflfp receive_msg(_id, %GreenHouse.Event{type: :humidity_sensor, value: val}) when val < 0.3 do
    cast_activate_layer(%{:humidity => :low})
  end

  deflfp receive_msg(_id, %GreenHouse.Event{type: :humidity_sensor, value: _val}) do
    cast_activate_layer(%{:humidity => :normal})
  end

  # default method
  deflfp receive_msg(_id, msg) do
    IO.puts "there is no function for the following message:#{inspect msg}"
  end

end
