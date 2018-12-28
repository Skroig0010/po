defmodule GreenHouse do
  use ContextEX
  @actors [0, 1]
  @fan_directions [{0, 1, :"0"}]
  @type fan :: [{from :: integer, to :: integer, actor_id :: atom}]
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(@actors)
    actors = for n <- @actors do
      IO.inspect n
      actor_pid = Router.route(n, GreenHouse.Actor, :start, [String.to_atom(Integer.to_string(n))])
      # actuator
      Router.route(n, GreenHouse.Actuator.Humidifier, :start, [])
      Router.route(n, GreenHouse.Actuator.Heater, :start, [])
      Router.route(n, GreenHouse.Actuator.FanSystem, :start, [])
      Router.route(n, GreenHouse.Actuator.Window, :start, [])
      # sensor
      Router.route(n, GreenHouse.Sensor.MoistureSensor, :start, [actor_pid])
      Router.route(n, GreenHouse.Sensor.HumiditySensor, :start, [actor_pid])
      Router.route(n, GreenHouse.Sensor.Thermometer, :start, [actor_pid])
    end

    init_context(:sink)
    loop()
  end

  deflfp temperature_compare(from, to), %{:month => month} when month >= 9 or month < 4 do
    from === :normal && to === :cold
  end

  deflfp temperature_compare(from, to), %{:month => month} do
    from === :normal && to === :hot
  end

  def loop() do
    # こんな使い方していいのか？
    # 10分に1回調べるとかしたいんだけど10分間ファン点きっぱなしになる
    map = get_activelayers()
    @fan_directions |> Enum.map(fn [from, to, actor_id] ->
      if(temperature_compare(map |> Map.get(from), map |> Map.get(to))) do
        cast_activate_group(actor_id, %{:temperature_diff => true})
      else
        cast_activate_group(actor_id, %{:temperature_diff => false})
      end
    end)
  end
end
