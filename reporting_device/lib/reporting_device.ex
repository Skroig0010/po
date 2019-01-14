defmodule ReportingDevice do
  @type actor :: id :: integer
  @actors [160, 161, 162, 163]

  @spec start() :: pid
  def start() do
    ContextEX.start()
    Python.init()
    Router.connect_all(@actors)
    for id <- @actors do
      IO.inspect id
      Router.route(id, ReportingDevice.Actuator.ReportingDevice, :start, [])
      Router.route(id, ReportingDevice.Actuator.Display, :start, [])
      Router.route(id, ReportingDevice.Actor, :start, [false])
    end
    # sinkで起動したい
    pid = spawn_link(ReportingDevice.Actor, :start, [true])
    spawn_link(ReportingDevice.Sensor.HumanSensor, :start, [pid])
    spawn_link(ReportingDevice.Clock, :start, [])
  end
end
