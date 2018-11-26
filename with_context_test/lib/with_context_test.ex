defmodule WithContextTest do
  use ContextEX

  def start() do
    # start global context server
    ContextEX.start()
    spawn(fn ->
      init_context(:MyGroup)
      func()
    end)
  end

  def func() do
    with_context %{:layer => 1} do
      IO.inspect do_something()

      with_context %{:layer => 2, :layerB => 1} do
        IO.inspect do_something()

        with_context %{:layer => 3} do
          IO.inspect do_something()
        end

        IO.inspect do_something()
      end

      IO.inspect do_something()
    end
  end

  deflf do_something(), %{:layer => 1} do
    :a
  end
  deflf do_something(), %{:layer => 2} do
    :b
  end
  deflf do_something() do
    :c
  end
end
