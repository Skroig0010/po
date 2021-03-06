defmodule PingPong.Actor do
  use ContextEX

  def start() do
    Python.init()
    init_context(:actor)
    with_context(%{:mode => :debug}) do
      controller = spawn_link(PingPong.Controller, :start, [])
      Process.register(controller, :controller)
      bar = spawn_link(PingPong.Entity.Bar, :start, [])
      Process.register(bar, :bar)
      updater = spawn_link(PingPong.Updater, :start, [])
      loop()
    end
  end

  deflf loop(), %{:mode => :debug} do
    try do
      receive do
        # キー入力の値を取得
        %PingPong.Event.KeyEvent{value: val} -> send Process.whereis(:controller), Enum.map(val, String.to_atom)
      end
      # バーの位置を更新
      # ボールの位置を取得
      # 衝突判定
      # 描画
    catch
      _, e -> IO.puts "error: #{inspect e}"
    end
    loop()
  end

  # コンテキストに応じてレイヤーを切り替えるときに、前作ったプロセスに:killを送る

end
