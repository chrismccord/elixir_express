defmodule TweetAggregator.Search.Supervisor do
  use Supervisor.Behaviour

  def stop(server_name) do
    Process.exit Process.whereis(name(server_name)), :shutdown
  end

  def start_link(server_name, query) do
    :supervisor.start_link({:local, name(server_name)}, __MODULE__, [server_name, query])
  end

  def init([server_name, query]) do
    tree = [worker(TweetAggregator.Search.Server, [server_name, query])]
    supervise tree, strategy: :one_for_one
  end

  defp name(server_name) do
    :"supervisor_#{server_name}"
  end
end

