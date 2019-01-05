defmodule Secom.Joystick do
  @joystick :joystick_agent

  @type direction :: {up :: boolean, down :: boolean, left :: boolean, right :: boolean}
  @type action :: :pressed | :released

  def init() do
    Agent.start(fn -> {{false, false, false, false}, :released} end, [name: @joystick])
  end

  def update() do
    try do
      event_list = Python.call(:get_events, [])

      left = Enum.any?(event_list, fn {dir, _} -> dir == 'left' end)
      right = Enum.any?(event_list, fn {dir, _} -> dir == 'right' end)
      up = Enum.any?(event_list, fn {dir, _} -> dir == 'up' end)
      down = Enum.any?(event_list, fn {dir, _} -> dir == 'down' end)
      action = if(Enum.any?(event_list, fn {_, act} -> act == 'pressed' end)) do
        :pressed
      else
        :released
      end

      Agent.update(Process.whereis(@joystick), fn _ -> {{up, down, left, right}, action} end)
    catch
      x, e -> IO.puts "error on joystick: #{inspect e} : #{inspect x}"
    end
  end

  @spec get_direction() :: direction
  def get_direction() do 
    Agent.get(Process.whereis(@joystick), fn {dir, _} -> dir end)
  end

  @spec get_action() :: action
  def get_action() do
    Agent.get(Process.whereis(@joystick), fn {_, act} -> act end)
  end

end
