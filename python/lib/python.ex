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
    if(is_pid Process.whereis(@agent)) do
    Agent.get(Process.whereis(@agent), &(&1))
    |> :python.call(:sample, func, args)
    else
      :timer.sleep(100)
      call(func, args)
    end
  end
end
