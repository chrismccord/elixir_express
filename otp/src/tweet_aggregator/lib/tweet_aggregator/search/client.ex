defmodule TweetAggregator.Search.Client do
  alias TweetAggregator.GateKeeper
  alias TweetAggregator.Aggregator
  alias TweetAggregator.Search.Supervisor

  @base_url "https://api.twitter.com/1.1/"
  @limit 1

  defrecord Status, id: nil, text: "", username: nil, hash_tags: [], mentions: []
  defrecord Query, subscriber: nil, keywords: [], options: [], seen_ids: []

  def server_name, do: :"#{node}_search_server"
  def server_pid, do: Process.whereis(server_name)

  def poll(keywords, options \\ []) do
    Supervisor.start_link(server_name, Query.new(
      subscriber: spawn(fn -> do_poll end),
      keywords: keywords,
      options: options,
    ))
    send server_pid, :poll
  end
  defp do_poll do
    receive do
      {:results, results} ->
        IO.puts "Client: Notifying Aggregator of #{Enum.count results} result(s)"
        Enum.each results, &Aggregator.push(server_name, &1)
    end
    do_poll
  end

  def stop do
    Supervisor.stop(server_name)
  end

  def search(keywords, options \\ []) do
    count = Keyword.get options, :count, @limit

    get "search/tweets.json", count: count,
                              q: keywords_to_query_param(keywords),
                              result_type: 'recent'
  end

  def get(path, params) do
    url             = String.to_char_list! process_url("search/tweets.json")
    access_token    = String.to_char_list! GateKeeper.access_token
    access_secret   = String.to_char_list! GateKeeper.access_token_secret
    consumer_key    = String.to_char_list! GateKeeper.consumer_key
    consumer_secret = String.to_char_list! GateKeeper.consumer_secret
    consumer = {consumer_key, consumer_secret, :hmac_sha1}

    case :oauth.get(url, params, consumer, access_token, access_secret) do
      {:ok, response}  -> {:ok, parse_response(response)}
      {:error, reason} -> {:error, reason}
    end
  end

  def parse_response(response) do
    Enum.map to_json(response)["statuses"], fn status ->
      Status.new id: status["id"],
                 text: status["text"],
                 username: status["user"]["screen_name"]
    end
  end

  defp to_json(response) do
    response
    |> elem(2)
    |> to_string
    |> :jsx.decode
  end

  defp keywords_to_query_param(keywords) do
    keywords |> Enum.join(" OR ") |> String.to_char_list!
  end

  defp process_url(url), do: @base_url <> url
end

