defmodule PingPong.Updater do
  def start() do
    loop()
  end

  defp loop() do
    :timer.sleep(32)
    send Process.whereis(:bar), :update
    send Process.whereis(:renderer), :update
    loop()
  end
end
