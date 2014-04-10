defmodule AggregatorTest do
  use ExUnit.Case
  alias TweetAggregator.Aggregator

  setup do
    if Aggregator.has_leader?, do: Process.exit(Aggregator.leader_pid, :kill)
    :ok
  end

  test "#become_leader starts Aggregator process" do
    refute Aggregator.has_leader?
    Aggregator.become_leader
    assert Aggregator.has_leader?
  end
end
