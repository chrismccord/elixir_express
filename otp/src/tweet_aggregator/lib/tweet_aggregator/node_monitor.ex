defmodule TweetAggregator.NodeMonitor do

  def start_link do
    {:ok, spawn_link fn -> 
      :global_group.monitor_nodes true
      monitor
    end}
  end

  def monitor do
    receive do
      {:nodeup, node}   -> IO.puts "NodeMonitor: #{node} joined"
      {:nodedown, node} -> IO.puts "NodeMonitor: #{node} left"
    end
    monitor
  end
end

