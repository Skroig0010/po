defmodule GreenHouse.Date do
  use ContextEX

  def start() do
    IO.puts "start clock"
    init_context(:timer)
    loop()
  end

  deflf loop() do
    date = Date.utc_today()
    cast_activate_group(:actor, %{:month => date.month})
    :timer.sleep(10000)
    loop()
  end
end
