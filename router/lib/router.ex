defmodule Router do
  @spec route(integer, module, atom, [any()]) :: pid
  def route(n, module, fun, args) do
    with node_name = String.to_atom("a@192.168.2." <> Integer.to_string(n + 160))
    do
      if !(Node.list |> Enum.member?(node_name)) do
        Node.connect(node_name)
      end
      Node.spawn_link(node_name, module, fun, args)
    end
  end
end
