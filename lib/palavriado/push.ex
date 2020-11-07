defmodule Palavriado.Push do
  def run do
    schedulers = System.schedulers_online()

    counters = for _ <- 1..schedulers do
      Task.async(&counter/0)
    end

    extractors = for _ <- 1..schedulers do
      Task.async(fn -> extractor(counters) end)
    end

    Palavriado.files()
    |> Stream.flat_map(&File.stream!(&1, [:utf8], :line))
    # Round robin on extractors
    |> Stream.zip(Stream.cycle(extractors))
    |> Stream.each(fn {line, extractor} ->
      send(extractor.pid, {:line, line})
    end)
    |> Stream.run()

    for extractor <- extractors, do: send(extractor.pid, :done)
    for extractor <- extractors, do: Task.await(extractor, :infinity)
    for counter <- counters, do: send(counter.pid, :done)

    counters
    |> Enum.map(&Task.await(&1, :infinity))
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp extractor(counters) do
    receive do
      {:line, line} ->
        n_counters = length(counters)
        for word <- Palavriado.extract_words(line) do
          counter_idx = :erlang.phash2(word, n_counters)
          counter = Enum.at(counters, counter_idx)
          send(counter.pid, {:word, word})
        end
        extractor(counters)
      :done ->
        :ok
    end
  end

  defp counter(state \\ %{}) do
    receive do
      {:word, word} ->
        counter(Map.update(state, word, 1, & &1 + 1))
      :done ->
        state
    end
  end
end
