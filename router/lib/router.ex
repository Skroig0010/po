defmodule Router do
  @spec route(integer, module, atom, [any()]) :: pid
  def route(n, module, fun, args) do
    with node_name = String.to_atom("a@192.168.120." <> Integer.to_string(n + 160))
    do
      Node.spawn_link(node_name, module, fun, args)
    end
  end
end
