defmodule TweetAggregator.Mixfile do
  use Mix.Project

  def project do
    [ app: :tweet_aggregator,
      version: "0.0.1",
      elixir: "~> 0.12 or ~> 0.13-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { TweetAggregator, [] },
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:jsx, github: "talentdeficit/jsx"}
    ]
  end
end
