defmodule GateKeeperTest do
  use ExUnit.Case
  alias TweetAggregator.GateKeeper

  setup do
    if GateKeeper.has_leader?, do: Process.exit(GateKeeper.leader_pid, :kill)
    GateKeeper.become_leader
    :ok
  end

  test "#leader_pid" do
    assert GateKeeper.has_leader?
  end

  test "#access_token" do
    System.put_env "TWEET_ACCESS_TOKEN", "the access_token"
    assert GateKeeper.access_token == "the access_token"
  end

  test "#access_token_secret" do
    System.put_env "TWEET_ACCESS_TOKEN_SECRET", "the access_token_secret"
    assert GateKeeper.access_token_secret == "the access_token_secret"
  end

  test "#consumer_key" do
    System.put_env "TWEET_CONSUMER_KEY", "the consumer_key"
    assert GateKeeper.consumer_key == "the consumer_key"
  end

  test "#consumer_secret" do
    System.put_env "TWEET_CONSUMER_SECRET", "the consumer_secret"
    assert GateKeeper.consumer_secret == "the consumer_secret"
  end
end

