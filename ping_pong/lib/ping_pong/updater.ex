defmodule PingPong.Updater do
  def start() do
    loop()
  end

  defp loop() do
    :timer.sleep(30)
    send Process.whereis(:bar), :update
    send Process.whereis(:renderer), :update
  end
end
