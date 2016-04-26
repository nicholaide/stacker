defmodule StackerTest do
  use ExUnit.Case
  doctest Stacker
  
  # copid from https://forums.pragprog.com/forums/322/topics/Exercise:%20OTP-Applications-2

  setup do
    :sys.replace_state(Stacker.Server, fn {_old_state, pid} -> {["Howdy", "ho", "folks"], pid} end)
    :ok
  end
  
  test "the stack has initial values" do
    { stack, pid } = :sys.get_state Stacker.Server
    assert stack == ["Howdy", "ho", "folks"]
    refute pid == nil
  end

  test "can push onto the stack" do
    Stacker.Server.push "!!!"
    { stack, _pid } = :sys.get_state Stacker.Server
    assert stack == ["!!!", "Howdy", "ho", "folks"]
  end

  test "can pop items off stack" do
    assert Stacker.Server.pop == "Howdy"
    assert Stacker.Server.pop == "ho"
    assert Stacker.Server.pop == "folks"
  end


end
