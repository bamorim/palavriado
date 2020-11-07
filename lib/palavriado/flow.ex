defmodule Palavriado.Flow do
  def run do
    Palavriado.files()
    |> Stream.flat_map(&File.stream!(&1, [:utf8], :line))
    |> Flow.from_enumerable()
    |> Flow.flat_map(&Palavriado.extract_words/1)
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
    |> Enum.into(%{})
  end
end
