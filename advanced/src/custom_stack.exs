defmodule Stack.CustomServer do

  def start(initial_stack) do
    spawn_link fn ->
      Process.register self, :custom_server
      listen initial_stack
    end
  end

  def listen(stack) do
    receive do
      {sender, :pop} -> handle_pop(sender, stack)
      {:push, value} -> listen([value|stack])
    after 5000 ->
      IO.puts "Nothing to do"
      listen stack
    end
  end

  def handle_pop(sender, [head|tail]) do
    send sender, head
    listen tail
  end
end

defmodule Stack.CustomClient do
  def push(value) do
    send server_pid, {:push, value}
  end

  def pop do
    send server_pid, {self, :pop}
    receive do
      value -> value
    end
  end

  defp server_pid do
    Process.whereis :custom_server
  end
end
