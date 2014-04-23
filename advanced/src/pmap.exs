defmodule Mapper do

  def map(list, func) do
    do_map(list, func, [])
  end

  defp do_map([], func, results), do: Enum.reverse(results)
  defp do_map([head | tail], func, acc) do
    result = func.(head)
    do_map(tail, func, [result | acc])
  end

  def pmap(list, func) do
    list
    |> spawn_children(func, self)
    |> collect_results
  end

  defp spawn_children(list, func, parent) do
    map list, fn el ->
      spawn fn ->
        send parent, {self, func.(el)}
      end
    end
  end

  defp collect_results(pids) do
    map pids, fn pid ->
      receive do
        {^pid, result} -> result
      end
    end
  end
end
