defmodule Secom do
  @spec start() :: [pid]
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all([1])
    for n <- [1] do
      IO.inspect n
      Router.route(n, Secom.Actuator.Shutter, :start, [])
      Router.route(n, Secom.Actuator.Sprinkler, :start, [])
      Router.route(n, Secom.Actuator.ReportingDevice, :start, [])
      actor_pid = Router.route(n, Secom.Actor, :start, [n])
      Router.route(n, Secom.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.StopButton, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Thermometer, :start, [actor_pid])
      Router.route(n, Secom.Sensor.HumanSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Updater, :start, [actor_pid])
    end
    spawn_link(Secom.Clock, :start, [])
  end
end
