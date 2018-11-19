defmodule PingPong do
  @moduledoc """
  Documentation for PingPong.
  """

  def start() do
    ContextEX.start()
    Python.init()
    for n <- [0, 1, 2, 3] do
      IO.inspect n
      actor_pid = Router.route(n, PingPong.Actor, :start, [])
      Router.route(n, PingPong.Sensor.Controller, :start, [actor_pid])
    end
  end
end
