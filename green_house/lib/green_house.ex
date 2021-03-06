defmodule GreenHouse do
  use ContextEX
  @moduledoc """
  0 1
  2 3
  0->1
  0->2
  2->3
  """
  @type actor :: {address :: integer, actor_id :: atom}
  @actors [{160, :"0"}, {161, :"1"}, {162, :"2"}, {163, :"3"}]
  # @actors [{161, :"1"}]

  @type fan :: [{from :: atom, to :: atom, actor_id :: atom}]
  @fan_directions [{:"0", :"1", :"0"}]
  # @fan_directions []

  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(Enum.map(@actors, fn {id, _} -> id end))
    for {address, id} <- @actors do
      IO.puts "Address:" <> Integer.to_string(address) <> ", id:" <> Atom.to_string(id)
      actor_pid = Router.route(address, GreenHouse.Actor, :start, [id])
      Router.route(address, GreenHouse.Joystick, :start, [])
      # actuator
      Router.route(address, GreenHouse.Actuator.Humidifier, :start, [])
      Router.route(address, GreenHouse.Actuator.Heater, :start, [])
      Router.route(address, GreenHouse.Actuator.FanSystem, :start, [])
      Router.route(address, GreenHouse.Actuator.Window, :start, [])
      Router.route(address, GreenHouse.Actuator.Sprinkler, :start, [])
      # sensor
      Router.route(address, GreenHouse.Sensor.MoistureSensor, :start, [actor_pid])
      Router.route(address, GreenHouse.Sensor.HumiditySensor, :start, [actor_pid])
      Router.route(address, GreenHouse.Sensor.Thermometer, :start, [actor_pid])
    end
    spawn_link(GreenHouse.Date, :start, [])

    init_context(:sink)
    loop()
  end

  deflfp temperature_compare(from, to), %{:month => month} when month >= 9 or month < 4 do
    from === :normal && to === :cold
  end

  deflfp temperature_compare(from, to) do
    from === :normal && to === :hot
  end

  def loop() do
    # 10分に1回調べるとかしたいんだけど10分間ファン点きっぱなしになるから更新頻度を可変にするべきか
    map = get_activelayers()
    @fan_directions |> Enum.map(fn {from, to, actor_id} ->
      from_state = map |> Map.get(from, :normal)
      to_state = map |> Map.get(to, :normal)
      if(temperature_compare(from_state, to_state)) do
        cast_activate_group(actor_id, %{:temperature_diff => true})
      else
        cast_activate_group(actor_id, %{:temperature_diff => false})
      end
    end)
    :timer.sleep(1000)
    loop()
  end
end
