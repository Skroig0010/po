defmodule GreenHouse do
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all([0])
    actors = for n <- [0] do
      IO.inspect n
      humidifier = Router.route(n, GreenHouse.Actuator.Humidifier, :start, [])
      heater = Router.route(n, GreenHouse.Actuator.Heater, :start, [])
      fan = Router.route(n, GreenHouse.Actuator.FanSystem, :start, [])
      window = Router.route(n, GreenHouse.Actuator.Window, :start, [])
      actor_pid = Router.route(n, GreenHouse.Actor, :start, [humidifier, heater, fan, window])
      Router.route(n, GreenHouse.Sensor.MoistureSensor, :start, [actor_pid])
      Router.route(n, GreenHouse.Sensor.HumiditySensor, :start, [actor_pid])
      Router.route(n, GreenHouse.Sensor.Thermometer, :start, [actor_pid])
    end
  end
end
