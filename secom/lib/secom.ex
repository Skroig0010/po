defmodule Secom do
  @spec start() :: [pid]
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all([0, 1, 2])
    for n <- [0, 1, 2] do
      IO.inspect n
      actor_pid = Router.route(n, Secom.Actor, :start, [])
      Router.route(n, Secom.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(n, Secom.Sensor.Thermometer, :start, [actor_pid])
    end
  end
end
