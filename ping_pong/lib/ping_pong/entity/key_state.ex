defmodule PingPong.Entity.KeyState do
  @type t() :: %PingPong.Entity.KeyState{up: boolean, down: boolean, left: boolean, right: boolean}

  defstruct up: false, down: false, left: false, right: false
end
