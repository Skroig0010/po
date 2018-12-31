defmodule Secom do
  @type actor :: {id, floor}
  @actors [{0, 1}, {1, 1}, {2, 2}, {3, 2}]
  @spec start() :: [pid]
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(Enum.map(@actors, fn {id, _} -> id end))
    for {id, floor} <- @actors do
      IO.inspect id
      Router.route(n, Secom.Actuator.Shutter, :start, [])
      Router.route(n, Secom.Actuator.Sprinkler, :start, [])
      Router.route(n, Secom.Actuator.ReportingDevice, :start, [])
      Router.route(n, Secom.Actuator.Display, :start, [])
      actor_pid = Router.route(n, Secom.Actor, :start, [floor])
      Router.route(n, Secom.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.StopButton, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Thermometer, :start, [actor_pid])
      Router.route(n, Secom.Sensor.HumanSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Updater, :start, [actor_pid])
    end
    spawn_link(Secom.Clock, :start, [])
  end
end
