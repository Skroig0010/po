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
      Router.route(id, ReportingDevice.Actuator.Display, :start, [])
      pid = Router.route(id, ReportingDevice.Actor, :start, [false])
      Router.route(id, ReportingDevice.Sensor.HumanSensor, :start, [pid])
    end
    spawn_link(ReportingDevice.Actuator.ReportingDevice, :start, [])
    spawn_link(ReportingDevice.Clock, :start, [])
    loop()
  end

  def loop() do
    try do
      ReportingDevice.Actuator.ReportingDevice.update()
    catch
      x, e -> IO.puts "error at sink loop: #{inspect e} : #{inspect x}"
    end
    loop()
  end

end
