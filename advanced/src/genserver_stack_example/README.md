# Managing state in an immutable language

This application shows how to manage and hold state via "homegrown" processes and how OTP conventions have been 
built up around these ideas.

While Elixir is immutable, state can be held in processes that continously recurse on themselves. Processes can then accept messages from other processes to return or change their current state.

Example:

```elixir
defmodule Stack.CustomServer do

  def start(initial_stack) do
    spawn_link fn -> 
      :global.register_name :custom_server, self
      listen initial_stack
    end
  end

  def listen(stack) do
    receive do
      {sender, :pop}         -> handle_pop(sender, stack)
      {sender, :push, value} -> listen([value|stack])
    end
  end

  def handle_pop(sender, []) do
    sender <- nil
    listen []
  end
  def handle_pop(sender, stack) do
    sender <- hd(stack)
    listen tl(stack)
  end
end
```

"Starting" the Custom stack server involves spawning a process that continually recurses on `listen` with the stack's current state. To push a value onto the stack, the process listens for a message containing the sender's pid, and a value `{sender, :push, value}` and then recurses back on itself with the value placed in the head of the stack. Similarly, to pop a value off the stack, the process listens for `{sender, :pop}` and sends the top of the stack as a message gack to the sender, then recurses back on itself with the popped value removed.

## Erlang/OTP Conventions
The OTP library brings tried and true conventions to holding state, process supervisionm, and message passing. For almost all cases where state needs to be held, it should be placed in an OTP gen_server.

## Homegrown Server Example
```elixir
$ iex -S mix
iex(1)> Stack.CustomServer.start [1, 2, 3]
#PID<0.101.0>
iex(2)> Stack.CustomClient.pop
1
iex(3)> Stack.CustomClient.pop
2
iex(4)> Stack.CustomClient.pop
3
```

## Using OTP gen_server

```elixir
$ iex -S mix
iex(1)> Stack.Client.start [1, 2, 3]
{:ok, #PID<0.74.0>}
iex(2)> Stack.Client.pop
1
iex(3)> Stack.Client.pop
2
iex(4)> Stack.Client.pop
3
iex(5)> Stack.Client.pop
nil


```
