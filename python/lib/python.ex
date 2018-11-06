defmodule Python do
  @agent :PyAgent

  def init() do
    unless(is_pid Process.whereis(@agent)) do
       try do
	 {:ok, python} = :python.start([python_path: '.'])
         Agent.start(fn -> python end, [name: @agent])
       rescue
         e -> e
       end
     end
  end

  def call(func, args) do
    Agent.get(@agent, &(&1))
    |> :python.call(:sample, func, args)
  end
end
