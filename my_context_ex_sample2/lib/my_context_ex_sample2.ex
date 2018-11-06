defmodule MyContextExSample2 do
  def start() do
    Python.init()
    actors = for n <- 1..1 do
      actor_pid = Router.route(n, MyContextExSample2.Actor, :start, [])
      Router.route(n, MyContextExSample2.Sensor.SmokeSensor, :start, [actor_pid])
      Router.route(n, MyContextExSample2.Sensor.Thermometer, :start, [actor_pid])
    end
  end
end
