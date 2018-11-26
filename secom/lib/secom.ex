defmodule Secom do
  @spec start() :: [pid]
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all([0])
    for n <- [0] do
      IO.inspect n
      actor_pid = Router.route(n, Secom.Actor, :start, [])
      Router.route(n, Secom.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Thermometer, :start, [actor_pid])
      Router.route(n, Secom.Sensor.HumanSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Updater, :start, [actor_pid])
    end
    spawn_link(Secom.Clock, :start, [])
  end
end
