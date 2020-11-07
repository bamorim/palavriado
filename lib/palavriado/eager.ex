defmodule Palavriado.Eager do
  def run do
    Palavriado.files()
    |> Enum.map(&File.read!/1)
    |> Enum.flat_map(&Palavriado.extract_words/1)
    |> Enum.reduce(%{}, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)
  end
end
