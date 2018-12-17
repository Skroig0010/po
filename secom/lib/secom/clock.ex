defmodule Secom.Clock do
  use ContextEX

  def start() do
    IO.inspect "clock 0"
    init_context(:timer)
    loop()
  end

  deflf loop() do
    :timer.sleep(1000)
    time = Time.utc_now()
    cast_activate_group(:actor, %{:time => time.hour})
    loop()
  end
end
