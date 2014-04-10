defmodule TweetAggregator.Aggregator do
  use GenServer.Behaviour
  alias TweetAggregator.Search.Client.Status

  def become_leader do
    start_link
  end

  def leader_pid do
    :global.whereis_name :aggregator
  end

  def has_leader?, do: leader_pid !== :undefined

  def start_link do
    :gen_server.start_link({:global, :aggregator}, __MODULE__, [], [])
  end

  def init(_) do
    {:ok, []}
  end

  def handle_cast({:push, server_name, status}, statuses) do
    log(server_name, status)
    {:noreply, [status | statuses]}
  end

  def push(server_name, status) do
    :gen_server.cast {:global, :aggregator}, {:push, server_name, status}
  end

  defp log(server_name, Status[text: text, username: username]) do
    IO.puts """
    >> #{server_name}
    @#{username}: #{text}
    """
  end
end

