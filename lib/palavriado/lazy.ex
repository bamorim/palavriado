defmodule Palavriado.Lazy do
  def run do
    Palavriado.files()
    |> Stream.flat_map(&File.stream!(&1, [:utf8], :line))
    |> Stream.flat_map(&Palavriado.extract_words/1)
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
  end
end
