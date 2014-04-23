defmodule Counter.Server do

  def start(initial_count \\ 0) do
    spawn fn -> listen(initial_count) end
  end

  defp listen(count) do
    receive do
      :inc -> listen(count + 1)
      :dec -> listen(count - 1)
      {sender, :val} ->
        send sender, count
        listen(count)
    end
  end

end

defmodule Counter.Client do

  def inc(pid), do: send(pid, :inc)
  def dec(pid), do: send(pid, :dec)
  def val(pid) do
    send pid, {self, :val}
    receive do
      val -> val
    end
  end
end

