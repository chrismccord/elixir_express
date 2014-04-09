defmodule Stack.Server do
  use GenServer.Behaviour

  def start_link(initial_stack) do
    :gen_server.start_link {:global, :stack_server}, __MODULE__, initial_stack, []
  end

  def init(initial_stack) do
    {:ok, initial_stack}
  end

  def handle_call(:pop, _from, []) do
    IO.puts "Pop empty"
    {:reply, nil, []}
  end

  def handle_call(:pop, from, [head | tail]) do
    IO.puts "Pop from #{inspect from} with #{head}"
    {:reply, head, tail}
  end

  def handle_cast({:push, value}, stack) do
    IO.puts "Pushing #{value}"
    {:noreply, [value|stack]}
  end
end


defmodule Stack.Client do

  def start(initial_stack \\ []) do
    Stack.Server.start_link(initial_stack)
  end

  def push(value) do
    :gen_server.cast {:global, :stack_server}, {:push, value}
  end

  def pop do
    :gen_server.call {:global, :stack_server}, :pop
  end
end
