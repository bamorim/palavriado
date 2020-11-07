defmodule Palavriado.Printer do
  def print(results) do
    for {size, counts} <- get_top_results_by_length(results) do
      IO.puts("Top words with size #{size}:")
      for {key, val} <- counts do
        IO.puts("#{key}: #{val}")
      end
      IO.puts("")
    end
    :ok
  end

  defp get_top_results_by_length(counts) do
    counts
    |> Enum.group_by(fn {word, _count} -> String.length(word) end)
    |> Enum.sort_by(fn {length, _counts} -> length end)
    |> Enum.map(fn {length, counts} ->
      counts =
        counts
        |> Enum.sort_by(fn {_word, count} -> 0 - count end)
        |> Enum.take(10)
      {length, counts}
    end)
  end
end
