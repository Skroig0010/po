defmodule TimeMeasurer do
  @tm_agent :TimeMeasurerAgent

  @spec init() :: pid()
  def init() do
    unless (is_pid Process.whereis(@tm_agent)) do
      try do
        Agent.start(fn -> {nil, []} end, [name: @tm_agent])
      rescue
        e -> e
      end
    end
  end

  @spec reset() :: Time.t()
  def reset() do
    with tm_pid = Process.whereis(@tm_agent),
         time = Time.utc_now() 
    do
      Agent.update(tm_pid, fn _ -> {time, []} end)
    end
  end

  @spec lap() :: integer()
  def lap() do
    with tm_pid = Process.whereis(@tm_agent),
         time = Time.utc_now()
    do
      t = Agent.get_and_update(tm_pid, fn {t, x} -> {t, {t, [time | x]}} end)
         Time.diff(time, t, :millisecond)
    end
  end

  @spec get_time() :: integer()
  def get_time() do
    with tm_pid = Process.whereis(@tm_agent),
         time = Time.utc_now()
    do
      t = Agent.get(tm_pid, fn { t, _} -> t end)
         Time.diff(time, t, :millisecond)
    end
  end

  @spec get_list() :: integer()
  def get_list() do
    with tm_pid = Process.whereis(@tm_agent)
    do
      Agent.get(tm_pid, fn {t, xs} -> 
        Enum.map(xs, fn x ->
          Time.diff(x, t, :millisecond)
        end)
      end)
    end
  end
end
