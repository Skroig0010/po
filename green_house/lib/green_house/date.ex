defmodule GreenHouse.Date do
  use ContextEX

  def start() do
    IO.puts "start clock"
    init_context(:date)
    loop()
  end

  deflfp loop() do
    date = Date.utc_today()
    cast_activate_group(:actor, %{:month => 8})
    cast_activate_group(:sink, %{:month => 8})
    # cast_activate_group(:actor, %{:month => date.month})
    # cast_activate_group(:sink, %{:month => date.month})
    :timer.sleep(10000)
    loop()
  end
end
