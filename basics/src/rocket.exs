defmodule Rocket do

  def start_launch_sequence(from \\ 10) when from >= 0 and from < 20 do
    IO.puts "Liftoff in #{from}..."
    countdown(from)
  end

  defp countdown(0), do: blastoff
  defp countdown(seconds) do
    IO.puts seconds
    countdown(seconds - 1)
  end

  def blastoff do
    IO.puts "Liftoff!"
  end
end

Rocket.start_launch_sequence

