defmodule Router do
  @node_prefix "a@192.168.120."
  @spec connect_all([integer]) :: any
  def connect_all(lst) do
    for n <- lst do
      with node_name = String.to_atom(@node_prefix <> Integer.to_string(n))
      do
        IO.puts "connecting #{inspect node_name}... #{inspect Node.connect(node_name)}"
      end
    end
    wait_connect(Enum.count(lst))
  end

  @spec wait_connect(integer) :: any
  defp wait_connect(n) do
    if(n != Enum.count(Node.list())) do
      IO.puts "wait for connecting #{inspect Enum.count(Node.list())}/#{inspect n}"
      :timer.sleep(1000)
      wait_connect(n)
    end
  end

  @spec route(integer, module, atom, [any()]) :: pid
  def route(n, module, fun, args) do
    with node_name = String.to_atom(@node_prefix <> Integer.to_string(n))
    do
      IO.puts "start #{inspect module}.#{inspect fun}#{inspect args}"
      Node.spawn_link(node_name, module, fun, args)
    end
  end
end
