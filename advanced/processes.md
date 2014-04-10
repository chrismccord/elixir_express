# Processes - Elixir's Unit of Concurrency
Elixir processes are fast and lightweight units of concurrency. Not to be confused with OS processes, millions of them can be spawned on a single machine, and each are managed entirely by the Erlang VM. Processes live at the core of Elixir application architectures and can send and receive messages to other processes located locally, or remotely on another connected Node.

### spawn
Spawn creates a new process and returns the Pid, or Process ID of the new process. Messages are sent to the processes using the `send/2` function.

### Mailboxes
Processes all contain a *mailbox* where messages are passively kept until consumed via a `receive` block. `receive` processes message in the order received and allows messages to be pattern matched. A common pattern is to send a message to a process with a tuple containing `self` as the first element. This allows the receiving process to have a reference to message's "sender" and respond back to the sender Pid with its own response messages.

```elixir
pid = spawn fn ->
  receive do
    {sender, :ping} ->
      IO.puts "Got ping"
      send sender, :pong
  end
end

send pid, {self, :ping}

# Got ping

receive do
  message -> IO.puts "Got #{message} back"
end

# Got pong back
```

`receive` blocks the current process until a message is received that matches a message clause. An `after` clause can optionally be provided to exit the receive loop if no messages are receive after a set amount of time.

```elixir
receive do
  message -> IO.inspect message
after 5000 ->
  IO.puts "Timeout, giving up"
end
```

Results in...
```elixir
# Timeout, giving up
```

## spawn_link
Similar to `spawn`, `spawn_link` creates a new process, but links the current and new process so that if one crashes, both processes terminate. Linking processes is essential to the Elixir and Erlang philosophy of letting programs crash instead of trying to rescue from errors. Since Elixir programs exist as a hierarchy of many processes, linking allows a predictable process dependency tree where failures in one process cascade down to all other dependent processes.

```elixir
pid = spawn_link fn ->
  receive do
    :boom -> raise "boom!"
  end
end

send pid, :boom
```
Results in...
```elixir
=ERROR REPORT==== 27-Dec-2013::16:49:14 ===
Error in process <0.64.0> with exit value: {{'Elixir.RuntimeError','__exception__',<<5 bytes>>},[{erlang,apply,2,[]}]}

** (EXIT from #PID<0.64.0>) {RuntimeError[message: "boom!"], [{:erlang, :apply, 2, []}]}
```

pid = spawn fn ->
  receive do
    :boom -> raise "boom!"
  end
end

send pid, :boom
```

Results in...
```elixir
=ERROR REPORT==== 27-Dec-2013::16:49:50 ===
Error in process <0.71.0> with exit value: {{'Elixir.RuntimeError','__exception__',<<5 bytes>>},[{erlang,apply,2,[]}]}

iex(5)>
```

The first example above using `spawn_link`, we see the process termination cascade to our own iex session from the `** (EXIT from #PID<0.64.0>)` error. Our iex session stays alive because it is internally restarted by a process Supervisor. Supervisors are covered in the next section on OTP.
