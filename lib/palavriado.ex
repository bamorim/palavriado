defmodule Palavriado do
  @moduledoc """
  Count words
  """

  alias Palavriado.Eager
  alias Palavriado.Lazy
  alias Palavriado.Printer
  alias Palavriado.Push
  alias Palavriado.Pull

  @not_char_regex ~r/[^A-Za-z0-9À-ÖØ-öø-ÿ-]/
  @min_word_length 3
  @original_files Path.wildcard("../machado/txt/*.txt")
  @files (
    @original_files
    |> Stream.cycle()
    |> Enum.take(length(@original_files) * 1)
  )

  def benchmark do
    Benchee.run(
      %{
        "eager" => &Eager.run/0,
        "lazy" => &Lazy.run/0,
        "push" => &Push.run/0,
        "pull" => &Pull.run/0
      },
      time: 5
    )
  end

  def eager do
    Eager.run() |> Printer.print()
  end

  def lazy do
    Lazy.run() |> Printer.print()
  end

  def push do
    Push.run() |> Printer.print()
  end

  def files, do: @files

  def extract_words(words) do
    words
    |> String.split(@not_char_regex)
    |> Enum.filter(&String.length(&1) >= @min_word_length)
    |> Enum.filter(&String.valid?/1)
    |> Enum.map(&String.downcase/1)
  end
end
