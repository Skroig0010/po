defmodule GreenHouse.Joystick do
  @joystick :joystick_agent

  @type direction :: {up :: boolean, down :: boolean, left :: boolean, right :: boolean}
  @type action :: :pressed | :released

  def init() do
    Agent.start(fn -> {{false, false, false, false}, :released} end, [name: @joystick])
  end

  def update() do
    event_list = Python.call(:get_events, [])

    left = Enum.any?(event_list, fn [_, dir] -> dir == 'left' end)
    right = Enum.any?(event_list, fn [_, dir] -> dir == 'right' end)
    up = Enum.any?(event_list, fn [_, dir] -> dir == 'up' end)
    down = Enum.any?(event_list, fn [_, dir] -> dir == 'down' end)
    action = if(Enum.any?(event_list, fn [act, _] -> act == 'pressed' || act == 'held' end)) do
      :pressed
    else
      :released
    end

    if(Process.whereis(@joystick) != nil) do
      Agent.update(Process.whereis(@joystick), fn _ -> {{up, down, left, right}, action} end)
    end
  end

  @spec get_direction() :: direction
  def get_direction() do 
    if(Process.whereis(@joystick) != nil) do
      Agent.get(Process.whereis(@joystick), fn {dir, _} -> dir end)
    end
  end

  @spec get_action() :: action
  def get_action() do
    if(Process.whereis(@joystick) != nil) do
      Agent.get(Process.whereis(@joystick), fn {_, act} -> act end)
    end
  end

end
