defmodule ReportingDevice.Clock do
  use ContextEX

  def start() do
    IO.inspect "clock 0"
    init_context(:timer)
    loop()
  end

  deflf loop() do
    time = Time.utc_now()
    cast_activate_group(:actor, %{:time => 1})
    # cast_activate_group(:actor, %{:time => time.hour})
    :timer.sleep(1000)
    loop()
  end
end
