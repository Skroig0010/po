defmodule ReportingDeviceTest do
  use ExUnit.Case
  doctest ReportingDevice

  test "greets the world" do
    assert ReportingDevice.hello() == :world
  end
end
