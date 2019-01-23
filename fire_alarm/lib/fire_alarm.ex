defmodule FireAlarm do
  @type actor :: {id :: integer, floor :: integer}
  @actors [{160, 1}, {161, 1}, {162, 2}, {163, 2}, {164, 3}, {165, 3}, {155, 1}, {156, 1}, {157, 3}, {158, 4}]
  @spec start() :: pid
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(Enum.map(@actors, fn {id, _} -> id end))
    for {id, floor} <- @actors do
      IO.inspect id
      Router.route(id, FireAlarm.Actuator.Shutter, :start, [])
      Router.route(id, FireAlarm.Actuator.Sprinkler, :start, [])
      Router.route(id, FireAlarm.Actuator.Display, :start, [])
      actor_pid = Router.route(id, FireAlarm.Actor, :start, [floor])
      Router.route(id, FireAlarm.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(id, FireAlarm.Sensor.StopButton, :start, [actor_pid])
      Router.route(id, FireAlarm.Sensor.Thermometer, :start, [actor_pid])
      Router.route(id, FireAlarm.Sensor.Updater, :start, [actor_pid])
    end
  end
end
