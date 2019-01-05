defmodule Secom do
  @type actor :: {id :: integer, floor :: integer}
  # @actors [{160, 1}, {161, 1}, {162, 2}, {163, 2}]
  @actors [{161, 1}]
  @spec start() :: pid
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(Enum.map(@actors, fn {id, _} -> id end))
    for {id, floor} <- @actors do
      IO.inspect id
      Router.route(id, Secom.Actuator.Shutter, :start, [])
      Router.route(id, Secom.Actuator.Sprinkler, :start, [])
      Router.route(id, Secom.Actuator.ReportingDevice, :start, [])
      Router.route(id, Secom.Actuator.Display, :start, [])
      actor_pid = Router.route(id, Secom.Actor, :start, [floor])
      Router.route(id, Secom.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(id, Secom.Sensor.StopButton, :start, [actor_pid])
      Router.route(id, Secom.Sensor.Thermometer, :start, [actor_pid])
      Router.route(id, Secom.Sensor.HumanSensor, :start, [actor_pid])
      Router.route(id, Secom.Sensor.Updater, :start, [actor_pid])
    end
    spawn_link(Secom.Clock, :start, [])
  end
end
