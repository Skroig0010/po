defmodule GreenHouse do
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all([0])
    actors = for n <- [0] do
      IO.inspect n
      actor_pid = Router.route(n, GreenHouse.Actor, :start, [])
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
  end
end
