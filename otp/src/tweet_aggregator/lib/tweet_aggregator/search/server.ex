defmodule TweetAggregator.Search.Server do
  use GenServer.Behaviour
  alias TweetAggregator.Search.Client
  alias TweetAggregator.Search.Client.Query

  @poll_every_ms 10000

  def start_link(server_name, query) do
    :gen_server.start_link({:local, server_name}, __MODULE__, [query], [])
  end

  def init([query]) do
    Process.flag(:trap_exit, true)
    {:ok, timer} = :timer.send_interval(@poll_every_ms, :poll)
    {:ok, {timer, query}}
  end

  def handle_info(:poll, {timer, query}) do
    {:ok, statuses} = Client.search(query.keywords, query.options)
    if new_results?(statuses, query) do
      send query.subscriber, {:results, statuses}
      {:noreply, {timer, record_seen_ids(statuses, query)}}
    else
      IO.puts "Client: No new results"
      {:noreply, {timer, query}}
    end
  end

  def record_seen_ids(statuses, query) do
    query.seen_ids(query.seen_ids ++ seen_ids(statuses))
  end

  def new_results?(statuses, query) do
    !Enum.find(seen_ids(statuses), fn id -> id in query.seen_ids end)
  end

  def seen_ids(statuses) do
    statuses |> Enum.map(&(&1.id))
  end

  def terminate(:shutdown, {timer, query}) do
    :timer.cancel(timer)
    Process.exit query.subscriber, :kill
    :ok
  end
end

