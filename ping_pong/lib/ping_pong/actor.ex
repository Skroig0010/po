defmodule PingPong.Actor do
  use ContextEX

  def start() do
    Python.init()
    init_context(:actor)
    with_context(%{:mode => :debug}) do
      controller = spawn_link(PingPong.Controller, :start, [])
      Process.register(controller, :controller)
      loop()
    end
  end

  deflf loop(), %{:mode => :debug} do
    try do
      receive do
        # キー入力の値を取得
        %PingPong.KeyEvent{value: val} -> send Process.whereis(:controller), val
      end
      # バーの位置を更新
      # ボールの位置を取得
      # 死亡判定
      # 描画
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop()
  end

end
