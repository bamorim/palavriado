defmodule Palavriado.Pull do
  alias Palavriado.Pull.Counter
  alias Palavriado.Pull.Extractor
  def run do
    {counters, extractors, producer} = start_stages()

    for extractor <- extractors do
      GenStage.sync_subscribe(extractor, to: producer, max_demand: 10)

      for {counter, i} <- Enum.with_index(counters) do
        GenStage.sync_subscribe(counter, to: extractor, max_demand: 10, partition: i)
      end
    end

    Enum.reduce(counters, %{}, fn counter, acc ->
      receive do
        {:done, ^counter, counts} ->
          Map.merge(acc, counts)
      end
    end)
  end

  def start_stages do
    schedulers = System.schedulers_online()

    counters = for _ <- 1..schedulers do
      {:ok, counter} = GenStage.start(Counter, self())
      counter
    end

    extractors = for _ <- 1..schedulers do
      {:ok, extractor} = GenStage.start(Extractor, schedulers)
      extractor
    end

    {:ok, producer} =
      Palavriado.files()
      |> Stream.flat_map(&File.stream!(&1, [:utf8], :line))
      |> GenStage.from_enumerable()

    {counters, extractors, producer}
  end
end
