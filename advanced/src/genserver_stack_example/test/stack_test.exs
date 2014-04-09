defmodule StackTest do
  use ExUnit.Case
  alias Stack.Client
  alias Stack.Server

  setup do
    Client.start
    :ok
  end

  test "pushing adds items to the top of the stack" do
    Client.push(1)
    Client.push(2)
    Client.push(3)
 
    assert Client.pop == 3
    assert Client.pop == 2
    assert Client.pop == 1
  end

  test "popping from and empty stack returns nil" do
    assert Client.pop == nil
  end
end
